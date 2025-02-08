Shader "Custom/TwoColorHeightFog"
{
    Properties
    {
        [Header(Fog Color)]
        _ColorA ("Primary Fog Color", Color) = (1,1,1,0.5)
        _ColorB ("Secondary Fog Color", Color) = (0.8,0.8,0.8,0.5)

        [Header(Fog Setting)]
        _HeightMin ("Fog Min Height", Range(0,10)) = 0
        _HeightMax ("Fog Max Height", Range(0,50)) = 0.25   
        _FogOpacity ("Fog Opacity", Range(0,1)) = 1
        _FogParticleFade("Fog Particle Fade Amount", Range(0, 10)) = 0.25 //Also refer to as Soft Particle Fade Amount
        
        [Header(Noise Setting)]
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _NoiseScale ("Noise Scale", Float) = 1
        _NoiseSpeed ("Noise Movement", Vector) = (0.1,0.1,0,0)
        _NoiseThreshold ("Noise Threshold", Range(0,1)) = 0.15
        _NoiseSoftness ("Noise Edge Softness", Range(0,1)) = 0.5
    }
    
    SubShader
    {
        Tags { 
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "RenderPipeline" = "UniversalPipeline"
        }
        
        Pass
        {
            Name "Forward"
            Tags { "LightMode" = "UniversalForward" }
            
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Back
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #pragma multi_compile_local _ _SOFTPARTICLES_ON
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            
            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS : TEXCOORD0;
                float2 uv : TEXCOORD1;
                float4 projectedPosition : TEXCOORD2;
                float fogFactor : TEXCOORD3;
            };
            
            TEXTURE2D(_NoiseTex);
            SAMPLER(sampler_NoiseTex);
            
            float4 _ColorA;
            float4 _ColorB;
            float _HeightMin;
            float _HeightMax;
            float _FogOpacity;
            float4 _NoiseTex_ST;
            float _NoiseScale;
            float4 _NoiseSpeed;
            float _NoiseThreshold;
            float _NoiseSoftness;
            float _FogParticleFade;
            
            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionWS = TransformObjectToWorld(input.positionOS.xyz);
                output.positionCS = TransformWorldToHClip(output.positionWS);
                output.uv = input.uv;

                // calucation values for the fog
                output.projectedPosition = ComputeScreenPos(output.positionCS);
                output.fogFactor = ComputeFogFactor(output.positionCS.z);

                return output;
            }
            
            // Some parts of the code in fragment is adapted from Unity Technologies's Particles Unlit code
            // which is found from https://github.com/Unity-Technologies/Graphics/blob/master/Packages/com.unity.render-pipelines.universal/ShaderLibrary/Particles.hlsl
            // or in here, https://github.com/Unity-Technologies/Graphics/tree/master/Packages/com.unity.render-pipelines.universal within Shader or ShaderLibrary folder
            // Outside of that, some of the code is also adapted from some of my other effects like the Volumetric spotlight shader graph and gradient based fog effect shader graph
            float4 frag(Varyings input) : SV_Target
            {
                // Calculate scene depth difference to be used in the soft particles within unity fog
                float sceneZ = LinearEyeDepth(SampleSceneDepth(input.projectedPosition.xy / input.projectedPosition.w), _ZBufferParams);
                float fadeAmount = saturate((sceneZ - input.projectedPosition.w) / _FogParticleFade);
                
                // Calculate the fog height factor, and then invert it as the value from heightFactor is inverted
                // some of this code is adapted from my gradient fog effect shader graph (changed to suit the height based aspect)
                float heightFactor = saturate((input.positionWS.y - _HeightMin) / (_HeightMax - _HeightMin));
                heightFactor = 1 - heightFactor; 
                
                // sample noise texture with the calculated offset and scale
                // some of this code is adapted from my volumetric spotlight shader graph
                float2 noiseUV = input.uv * _NoiseScale + _NoiseSpeed.xy * _Time.y;
                float noiseValue = SAMPLE_TEXTURE2D(_NoiseTex, sampler_NoiseTex, noiseUV).r;
                
                // Create the noise to be used as a mask
                float noiseMask = smoothstep(_NoiseThreshold - _NoiseSoftness, _NoiseThreshold + _NoiseSoftness, noiseValue);
                
                // Apply the color to the correct areas on the noise mask, and then calculate our fog density
                float4 fogColor = lerp(_ColorB, _ColorA, noiseMask);
                float fogStrength = heightFactor * _FogOpacity;
                fogColor.a *= fogStrength * fadeAmount;
                
                // Apply unity fog on it with our fog color and fog factor
                // This is where is our fog for the height fog comes from
                fogColor.rgb = MixFog(fogColor.rgb, input.fogFactor);
                
                return fogColor;
            }
            ENDHLSL
        }
    }
}
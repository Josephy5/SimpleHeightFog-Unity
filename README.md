![TwoColorHeight](https://github.com/user-attachments/assets/430e949a-a72f-4631-b077-9892b48c5af9)

# Simple Height Fog Effect
![Unity Version](https://img.shields.io/badge/Unity-6000.0.27%27LTS%2B-blueviolet?logo=unity)
![Unity Pipeline Support (Built-In)](https://img.shields.io/badge/BiRP_✔️-darkgreen?logo=unity)
![Unity Pipeline Support (URP)](https://img.shields.io/badge/URP_✔️-blue?logo=unity)
![Unity Pipeline Support (HDRP)](https://img.shields.io/badge/HDRP_✔️-darkred?logo=unity)
 
A shader effect that simulates height fog on a plane mesh. It was created for Serious Point Games as part of my studies in shader development. It was created for Unity 6 URP (6000.0.27f1) 
but it can work in other unity versions (like Unity 2022 or Unity 2019) and other pipelines (like Built-In).


It comes in two variants, one being a simple height fog (using Unity’s built in particle unlit shader which can be 
used to re-create a height fog) and a custom two color height fog.

You can refer to the effect's documentation for more info (should be in the repo and its release as a PDF file).

## Features
- Simulate height fog in areas only covered by the plane mesh, saving resources unlike the post processing approach
- Can add a noise texture to the fog, using a custom noise texture (2 Color Fog shader)
- Can also animate the noise texture within the fog (2 Color Fog shader)
- Customizable fog color & parameters

## Example[s]
![SimpleHeight](https://github.com/user-attachments/assets/61e388e2-fc76-46bd-928a-3c82ca0b8276)
What the simple height fog effect looks like with the effect on.
<br>
<br>
![TwoColorHeight](https://github.com/user-attachments/assets/430e949a-a72f-4631-b077-9892b48c5af9)
<br>
What the two color height fog eff ect looks like with the eff ect on, the red and off -white color is just used for demonstration purposes only to make the fog more apparent.

## Installation
1. Clone repo or download the folder and load it into an unity project.
2. Drag the material onto a plane gameobject/mesh that you want to apply the eff ect on, or go to the object’s inspector panel and change its material to the material with the 2 color height fog shader.
3. [Optional] If you want to use the simple fog one like the one I implemented, create a new material, go to Universal Render Pipeline > Particles > Unlit, then enable soft particles and ensure the material’s
   surface type is on transparent instead of opaque.
4. Optionally, you can use one of the prefabs by clicking and dragging one of the prefabs into the scene. You can also scale the plane to make the height fog area bigger or smaller.

## Credits/Assets used
Some parts of the code is adapted from Unity Technologies's Particles Unlit code, which is found from https://github.com/Unity-Technologies/Graphics/blob/master/Packages/com.unity.render-pipelines.universal/ShaderLibrary/Particles.hlsl
or in here, https://github.com/Unity-Technologies/Graphics/tree/master/Packages/com.unity.render-pipelines.universal within Shader or ShaderLibrary folder

Some of the code is adapted from my other effects, like the Volumetric Spotlight Shader Graph and Gradient Fog Effect.

The method used to create the simple height fog eff ect is from this Youtube video by Vanmillion Studios, https://www.youtube.com/watch?v=-s7_l3TXWPM.

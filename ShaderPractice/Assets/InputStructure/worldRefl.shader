Shader "TestShader/WorldRefl"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        struct Input
        {
            float3 worldRefl;
        };

        void surf(Input IN, inout SurfaceOutputStandard o) {
            o.Albedo = fixed4(IN.worldRefl.x, IN.worldRefl.y, IN.worldRefl.z, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}

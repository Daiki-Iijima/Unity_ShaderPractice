Shader "TestShader/WorldPos"
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
            float3 worldPos;
        };

        void surf(Input IN, inout SurfaceOutputStandard o) {
            o.Albedo = fixed4(IN.worldPos.x, IN.worldPos.y, IN.worldPos.z, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}

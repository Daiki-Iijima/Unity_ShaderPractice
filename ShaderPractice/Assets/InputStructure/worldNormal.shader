Shader "TestShader/WorldNormal"
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
            float3 worldNormal;
        };

        void surf(Input IN, inout SurfaceOutputStandard o) {
            o.Albedo = fixed4(IN.worldNormal.x, IN.worldNormal.y, IN.worldNormal.z, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}

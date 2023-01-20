Shader "DShader/RimLighting"
{
    SubShader
    {
        Tags { 
            "RenderType" = "Opaque"
        }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        struct Input
        {
            float3 worldNormal;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = fixed4(1, 1, 1, 1);
            float cosTheta = 1 - dot(IN.viewDir, IN.worldNormal);
            cosTheta = pow(cosTheta,4);
            o.Emission = cosTheta;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
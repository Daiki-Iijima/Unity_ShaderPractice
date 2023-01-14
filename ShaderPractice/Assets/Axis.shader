Shader "DShader/Axis"
{
    Properties
    {
    }

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

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = float4(pow(IN.worldPos.x,4),pow(IN.worldPos.y,4),pow(IN.worldPos.z,4),1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}

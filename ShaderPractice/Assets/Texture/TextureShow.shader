Shader "DShader/TextureShow"
{
    Properties
    {
        _Tex("テクスチャ", 2D) = "white"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        //  テクスチャ
        sampler2D _Tex;

        struct Input
        {
            float2 uv_Tex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = tex2D(_Tex,IN.uv_Tex);
        }
        ENDCG
    }
    FallBack "Diffuse"
}

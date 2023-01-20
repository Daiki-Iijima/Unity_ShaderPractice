Shader "DShader/TextureShowColorAlpha"
{
    Properties
    {
        _Tex("テクスチャ", 2D) = "white"{}
        _AlphaColor("透過色",Color) = (1,1,1,1)
        _AlphaThreshold("透過閾値",float) = 0.1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard alpha:fade
        #pragma target 3.0

        //  テクスチャ
        sampler2D _Tex;
        float4 _AlphaColor;
        float _AlphaThreshold;

        struct Input
        {
            float2 uv_Tex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float4 color = tex2D(_Tex,IN.uv_Tex);
            o.Albedo = color.rgb;

            float diffR = abs(_AlphaColor.r - color.r);
            float diffG = abs(_AlphaColor.g - color.g);
            float diffB = abs(_AlphaColor.b - color.b);

            o.Alpha = (
            (diffR <= _AlphaThreshold) && 
            (diffG <= _AlphaThreshold) && 
            (diffB <= _AlphaThreshold)
            ) ? 0.0f : 1.0f;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

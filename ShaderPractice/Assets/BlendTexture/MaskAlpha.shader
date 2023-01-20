Shader "DShader/MaskAlpha"
{
    Properties
    {
        _MainTex ("メインテクスチャ", 2D) = "white" {}
        _MaskTex ("マスクテクスチャ", 2D) = "white" {}
        _Alpha("透明度",float) = 1
        _MaskThreshold("マスクの閾値",float) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard alpha:fade

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MaskTex;
        float _Alpha;
        float _MaskThreshold;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //  各テクスチャの色をテクスチャ座標をもとに抽出
            fixed4 mainTex = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 maskTex = tex2D (_MaskTex, IN.uv_MainTex);

            // 黒い部分を抜く 
            // 黒は(0,0,0)なので、0を掛けることになり、0になり、出力される画像は黒塗りになります。
            fixed4 c = mainTex;

            //  マスク画像をもとに、色を設定する
            if(maskTex.x < _MaskThreshold && maskTex.y < _MaskThreshold && maskTex.z < _MaskThreshold){
                o.Alpha = _Alpha;
                }else{
                o.Alpha = 1.0f;
            }

            o.Albedo = c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

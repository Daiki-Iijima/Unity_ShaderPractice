Shader "DShader/Toon"
{
  Properties
  {
    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Albedo (RGB)", 2D) = "white" {}
    _RampTex ("Ramp", 2D) = "white" {}
    _Shadow("影の量",float) = 0.5
    _RampUseRange("テクスチャの使用する範囲",float) = 0.5
  }
  SubShader
  {
    Tags { "RenderType"="Opaque" }
    LOD 200

    CGPROGRAM
    //  ライティングを使用するので、ライティング処理をフック(ToomRanp)
    #pragma surface surf ToonRamp
    #pragma target 3.0

    sampler2D _MainTex;
    sampler2D _RampTex;

    struct Input
    {
      float2 uv_MainTex;
    };

    fixed4 _Color;
    float _Shadow;
    float _RampUseRange;

    //  ライティングの設定を行う(Lightng+フックした変数名)
    fixed4 LightingToonRamp(SurfaceOutput s,fixed3 lightDir,fixed atten){
      //  光源ベクトルと、model法線の内積を求める
      //  マイナスになった場合、テクスチャの設定でClumpされて、UV座標は0になる
      half d = dot(s.Normal, lightDir) * _RampUseRange + _Shadow;
      //  dはX軸,0.5はuv座標の中心を取得するために設定している
      fixed3 ramp = tex2D(_RampTex,fixed2(d,0.5)).rgb;
      fixed4 c;
      //  モデルのテクスチャの色、ライトの光源の色、ランプテクスチャの色をかけ合わせて描画する色としている
      c.rgb = s.Albedo * _LightColor0.rgb * ramp;
      c.a = 0;
      return c;
    }

    void surf (Input IN, inout SurfaceOutput o)
    {
      //  テクスチャの色を取得
      fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
      o.Albedo = c.rgb;
      o.Alpha = c.a;
    }
    ENDCG
  }
  FallBack "Diffuse"
}

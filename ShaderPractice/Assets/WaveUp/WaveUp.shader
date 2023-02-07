Shader "Custom/WaveUp"
{
  Properties
  {
    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Albedo (RGB)", 2D) = "white" {}
    _Glossiness ("Smoothness", Range(0,1)) = 0.5
    _Metallic ("Metallic", Range(0,1)) = 0.0
    _Value("進捗度",Float) = 0
  }
  SubShader
  {
    Tags { "RenderType"="Opaque" }
    LOD 200

    CGPROGRAM
    // Physically based Standard lighting model, and enable shadows on all light types
    #pragma surface surf Standard vertex:vert

    // Use shader model 3.0 target, to get nicer looking lighting
    #pragma target 3.0

    sampler2D _MainTex;

    struct Input
    {
      float2 uv_MainTex;
    };

    half _Glossiness;
    half _Metallic;
    fixed4 _Color;
    float _Value;

    float rand(float2 co) //引数はシード値と呼ばれる　同じ値を渡せば同じものを返す
    {
      return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
    }

    //  頂点シェーダー
    void vert(inout appdata_full v, out Input o )
    {
      UNITY_INITIALIZE_OUTPUT(Input, o);

      float s = sin(_Time.w + v.vertex.x);

      //  モデルを_Value分動かす
      v.vertex.xyz = float3(v.vertex.x,v.vertex.y,v.vertex.z - 2 + clamp(_Value,0,1) * 2);

      //  自動で増加させる
      // v.vertex.xyz = float3(v.vertex.x,v.vertex.y,v.vertex.z - 2 +clamp(_Time.w / 20,0,1) * 2);

      //  一番より大きい場合、ウェーブさせる
      if(v.vertex.z > -1){
        v.vertex.z += (pow(s,2) / 4);
      }

      // モデルの上部より上にウェーブが行かないようにする
      if(v.vertex.z > 1){
        v.vertex.z = 1;
      }

      //  モデルの下からはみ出ないようにする 
      if(v.vertex.z <= -1){
        v.vertex.z = -1;
      }
    }

    // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
    // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
    // #pragma instancing_options assumeuniformscaling
    UNITY_INSTANCING_BUFFER_START(Props)
    // put more per-instance properties here
    UNITY_INSTANCING_BUFFER_END(Props)

    void surf (Input IN, inout SurfaceOutputStandard o)
    {
      // Albedo comes from a texture tinted by color
      fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
      o.Albedo = c.rgb;
      // Metallic and smoothness come from slider variables
      o.Metallic = _Metallic;
      o.Smoothness = _Glossiness;
      o.Alpha = c.a;
    }
    ENDCG
  }
  FallBack "Diffuse"
}

Shader "DShader/Vertex/Wave"
{
  Properties {

    _MainTex("メインテクスチャ",2D) ="wihte"{}
    _WaveSpeed("ウェーブの速度",Float) = 1
    _WaveDepth("ウェーブの深さ",Float) = 1
  }

  SubShader
  {
    Tags { "RenderType"="Opaque" }
    LOD 100
    Cull off

    CGPROGRAM
    #pragma surface surf Standard vertex:vert
    #pragma target 3.0

    sampler2D _MainTex;

    struct Input
    {
      float2 uv_MainTex;
    };

    float _WaveSpeed;
    float _WaveDepth;

    //  頂点シェーダー
    void vert(inout appdata_full v, out Input o )
    {
      UNITY_INITIALIZE_OUTPUT(Input, o);
      // float amp = sin(_Time.y * _WaveSpeed + v.vertex.x) * _WaveDepth;

      //  0 ~ 1までの範囲の値を使用
      float s = abs(sin(_Time.y));
      
      //  開ききったら固定する
      //  コメントアウトすると、動き続けてピラピラする
      if(_Time.y > 1.5f){
        s = 1;
      }
      
      float y = (s * (v.vertex.x + 5)) * 0.8f;
      float x = v.vertex.x - (pow(y * 2,2.2f) / 50) ;

      v.vertex.xyz = float3(x, y, v.vertex.z);
    }

    //  surfaceシェーダー
    void surf (Input IN, inout SurfaceOutputStandard o)
    {
      float4 c = tex2D(_MainTex,IN.uv_MainTex);
      o.Albedo = c;
    }
    ENDCG
  }
  FallBack "Diffuse"
}


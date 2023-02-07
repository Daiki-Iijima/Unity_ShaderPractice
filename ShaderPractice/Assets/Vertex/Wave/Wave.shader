Shader "DShader/Vertex/Wave"
{
  Properties {
  }

  SubShader
  {
    Tags { "RenderType"="Opaque" }
    LOD 100
    Cull off

    CGPROGRAM
    #pragma surface surf Standard vertex:vert
    #pragma target 3.0

    struct Input
    {
      float2 uv_MainTex;
    };

    //  頂点シェーダー
    void vert(inout appdata_full v, out Input o )
    {
      //  初期化
      UNITY_INITIALIZE_OUTPUT(Input, o);

      //  頂点の位置を加味することで出力される座標を動かす
      float amp = sin(_Time.y * 5 + v.vertex.x);

      //  座標を動かす
      v.vertex.xyz = float3(v.vertex.x,v.vertex.y + amp,v.vertex.z);
    }

    //  surfaceシェーダー
    void surf (Input IN, inout SurfaceOutputStandard o)
    {
      o.Albedo = float4(1,1,1,1);
    }
    ENDCG
  }
  FallBack "Diffuse"
}


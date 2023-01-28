Shader "DShader/VertexColor"
{
  SubShader
  {
    Tags { "RenderType"="Opaque" }
    LOD 200

    CGPROGRAM
    #pragma surface surf Standard vertex:vert
    #pragma target 3.0

    //  vertex関数とsurface関数の連絡用構造体
    struct Input
    {
      //  vert関数で値を設定して、surfで色を表示
      float4 vertColor;
    };

    void vert(inout appdata_full v, out Input o){
      //  Input構造体を初期化
      UNITY_INITIALIZE_OUTPUT(Input,o);
      //  Unityが持っている頂点カラー情報を構造体に代入してSurface処理に送る
      o.vertColor = v.color;
    }

    void surf (Input IN, inout SurfaceOutputStandard o)
    {
      //  Vertex処理から受け取った頂点カラー情報をmodelに表示
      o.Albedo = IN.vertColor.rgb;
    }
    ENDCG
  }
  FallBack "Diffuse"
}

Shader "DShader/Circle/MousePointDraw"
{
  Properties
  {
    _Radius("円の半径",Float) = 0
    _ClickPosX("クリック位置X",Float) = 0
    _ClickPosY("クリック位置Y",Float) = 0
    _ClickPosZ("クリック位置Z",Float) = 0
  }

  SubShader
  {
    Tags { "RenderType"="Opaque" }
    LOD 200

    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows
    #pragma target 3.0

    float _Radius;
    float _ClickPosX;
    float _ClickPosY;
    float _ClickPosZ;

    struct Input
    {
      float3 worldPos;
    };

    void surf (Input IN, inout SurfaceOutputStandard o)
    {
      //  マウスが現在ある地点からピクセルまでの距離を計算
      float dist = distance(float3(_ClickPosX,_ClickPosY,_ClickPosZ),IN.worldPos);

      //  ベースの色をつける
      o.Albedo = float4(1,0,0,1);

      //  距離が指定した半径以内の場合、色を変更する
      if(dist <= _Radius){
        o.Albedo = float4(1,1,1,1);
      }

    }
    ENDCG
  }
  FallBack "Diffuse"
}

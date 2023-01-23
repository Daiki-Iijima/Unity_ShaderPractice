Shader "DShader/Circle/Ring"
{
    Properties
    {
        _Radius("円の半径",Float) = 0
        _RingSpeed("リング速度",Float) = 0
        _Smallness("リングの小ささ",Float) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        float _Radius;
        float _RingSpeed;
        float _Smallness;

        struct Input
        {
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float dist = distance(float3(0,0,0),IN.worldPos);

            //  ベースの色をつける
            o.Albedo = float4(1,0,0,1);

            //  ループ回数を求める
            //  割り切れるか
            //  trunc : 小数点切り捨て
            float s = abs(sin(_Time.y * _RingSpeed));


            //  距離が指定した半径以内の場合、色を変更する
            if(dist >= _Radius && dist <= _Radius + s / _Smallness){
                o.Albedo = float4(1,1,1,1);
            }
        }
        ENDCG
    }
    FallBack "Diffuse"
}


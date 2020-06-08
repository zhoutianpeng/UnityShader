Shader "Unlit/008"
{
    Properties
    {
        //定义物体表面颜色
        _Diffuse("Diffuse", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //引用 Unity库
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            fixed4 _Diffuse;

            struct v2f
            {
                float4 vertex : SV_POSITION;
                fixed3 worldNormal: TEXCOORD0;   
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            //片元漫反射
            fixed4 frag(v2f i):SV_TARGET
            {
                //获取环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                //获取世界坐标系第一个直射光
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

                fixed3 diffuse = _LightColor0.rbg * _Diffuse * (dot(i.worldNormal, worldLight) * 0.5 + 0.5);
                fixed3 color = diffuse + ambient;

                return fixed4(color,1);
            }

            ENDCG
        }
    }
}

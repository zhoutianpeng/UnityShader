//属性控制
//Shader库中的输入输出结构体
    //我们在编写shader时，未显式的引用Unity shader库
    //因为在编译shader时，Unity会固定编译shader库/UnityCG.cginc

//顶点着色器 常见输入结构体语义
//POSITION 顶点位置 float4
//NORAML 顶点法线 float3
//TANGENT 顶点切线 float4
//TEXCOORDn 顶点的纹理坐标 float2/float4   Shader Model 2、3 n最多为8 | Shader Model 4、5 n最多为16
//COLOR 顶点的颜色 float4/fixed4

//顶点着色器 常见输出结构体语义
//SV_POSITION 裁剪空间顶点坐标 必须包含一个
//COLOR0 输出第一组顶点颜色 非必须
//COLOR1 输出第二组顶点颜色 非必须
//TEXCOORDn  输出纹理坐标 n 非必须 最多为7

//片元着色器 常见输出结构体语义
//SV_TARGET 输出值会存储到渲染目标中，C#获取render target 后可以编程1修改


Shader "Unlit/004"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
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
            

            //只有在CGPROGRAM内重新声明一个 名称&类型 与 Properties代码块中相同的变量，Properties代码块中变量才会生效
            fixed4 _Color;

            //输出结构体 vertex to fragment
            struct v2f
            {
                //SV_POSITION语义：通知Unity pos是裁剪空间中位置信息
                float4 pos:SV_POSITION;
                //COLOR0语义：可以储存颜色信息
                fixed3 color: COLOR0;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                //将取值从[-1，1]转换为[0，1]区间
                o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
                return o;
            }

            //SV_TARGET 返回颜色值，该值会输入到 RenderTarget中，RenderTarget帧缓存
            fixed4 frag(v2f i):SV_TARGET
            {
                fixed3  c = i.color;
                //使用_Color变量
                //fixed3.xyzw fixed3.rgba  fixed3.x fixed3.r fixed3.y fixed3.g等方式访问
                c *= _Color.rgb;
                //此时未处理透明通道，所以设置透明通道无效
                return fixed4(c,1);
            }

            ENDCG
        }
    }
}

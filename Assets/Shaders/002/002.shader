Shader "Unlit/002"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert //定义了顶点着色器的函数名称
            #pragma fragment frag //定义了片元着色器的函数名称

            //POSITION SV_POSITION:语义 CG以及HLSL中的语义，表达输入代表什么
            //POSITION 模型顶点信息
            //SV_POSITION 输出模型裁剪空间的顶点信息

            float4 vert(float4 v:POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(v);
            }

            //SV_TARGET 返回颜色值，该值会输入到 RenderTarget中，RenderTarget帧缓存
            fixed4 frag():SV_TARGET
            {
                return fixed4(1,1,1,1);
            }
            ENDCG
        }
    }
}

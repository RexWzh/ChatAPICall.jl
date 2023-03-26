# ChatAPICall

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://RexWzh.github.io/ChatAPICall.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://RexWzh.github.io/ChatAPICall.jl/dev/)
[![Build Status](https://github.com/RexWzh/ChatAPICall.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/RexWzh/ChatAPICall.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/RexWzh/ChatAPICall.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/RexWzh/ChatAPICall.jl)

OpenAI 的[API](https://platform.openai.com/docs/api-reference/introduction)的简单封装。

## 用法

### 设置 API 密钥

```julia
using ChatAPICall
setapikey("sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
```

或者在使用该包时设置 `OPENAI_API_KEY` 变量以自动加载 API 密钥:

```bash
# 将以下代码添加到 ~/.bashrc
export OPENAI_API_KEY="sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

### 设置代理 (可选)

```julia
using ChatAPICall

# 设置代理 (示例)
proxy_on(http="127.0.0.1:7890", https="socks://127.0.0.1:7891")

# 查看当前代理
proxy_status()

# 关闭代理
proxy_off() 
```

### 基础使用

示例1：发送消息并返回信息：

```julia
using ChatAPICall

# 检查 API 密钥是否设置
showapikey()

# 检查是否开启代理
proxy_status()

# 发送消息并返回响应
chat = Chat("Hello, GPT-3.5!")
resp = getresponse(chat)
```

示例2：自定义消息模板并返回信息和使用的令牌数：

```julia
using ChatAPICall

# 自定义发送模板
function ChatAPICall.defaultprompt(msg)
    [
        Dict("role"=>"system", "content"=>"帮我翻译这段文字"),
        Dict("role"=>"user", "content"=>msg)
    ]
end

chat = Chat("Hello!")
# 将重试次数设置为 Inf
response = getresponse(chat; temperature=0.5, maxrequests=-1)
println("Number of consumed tokens: ", response.total_tokens)
println("Returned content: ", response.content)
```



### 进阶使用

根据上一次的响应继续聊天：

```julia
# 第一次呼叫
chat = Chat("Hello, GPT-3.5!")
resp = getresponse!(chat) # 更新聊天记录
println(resp.content)

# 继续聊天
adduser!(chat, "How are you?")
next_resp = getresponse!(chat)
println(next_resp.content)

# 伪造响应
adduser!(chat, "What's your name?")
addassistant!(chat, "My name is GPT-3.5.")

# 打印聊天记录
print(chat)
```

## 许可证

本包使用 MIT 许可证。详见 LICENSE 文件。

## 特点

* 待完成
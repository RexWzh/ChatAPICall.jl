# ChatAPICall

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://RexWzh.github.io/ChatAPICall.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://RexWzh.github.io/ChatAPICall.jl/dev/)
[![Build Status](https://github.com/RexWzh/ChatAPICall.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/RexWzh/ChatAPICall.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/RexWzh/ChatAPICall.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/RexWzh/ChatAPICall.jl)

A simple wrapper for OpenAI's [API](https://platform.openai.com/docs/api-reference/introduction).

> 中文文档移步这里：[README_zh-CN.md](README_zh-CN.md)

## Usage

### Set API Key

```julia
using ChatAPICall
setapikey("sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
```

Or set `OPENAI_API_KEY` in `~/.bashrc` to automatically load the API key when using the package:

```bash
# Add the following code to ~/.bashrc
export OPENAI_API_KEY="sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

### Set Proxy (Optional)

```julia
using ChatAPICall

# Set proxy(example)
proxy_on(http="127.0.0.1:7890", https="socks://127.0.0.1:7891")

# Check the current proxy
proxy_status()

# Turn off proxy
proxy_off() 
```

Or you might want to use a proxy url (It is `https://api.openai.com` by default):

```julia
using ChatAPICall
setbaseurl("https://api.example.com")
```

### Basic Usage

Example 1, send prompt and return information:

```julia
using ChatAPICall

# Check if API key is set
showapikey()

# Check if proxy is enabled
proxy_status()

# Send prompt and return response
chat = Chat("Hello, GPT-3.5!")
resp = getresponse(chat)
```

Example 2, customize the message template and return the information and the number of consumed tokens:

```julia
using ChatAPICall

# Customize the sending template
function ChatAPICall.defaultprompt(msg)
    [
        Dict("role"=>"system", "content"=>"Please help me translate the following text."),
        Dict("role"=>"user", "content"=>msg)
    ]
end

chat = Chat("Hello!")
# Set the number of retries to Inf
response = getresponse(chat; temperature=0.5, maxrequests=-1)
println("Number of consumed tokens: ", response.total_tokens)
println("Returned content: ", response.content)
```

### Advanced Usage

Continue chatting based on the last response:

```julia
# first call
chat = Chat("Hello, GPT-3.5!")
resp = getresponse!(chat) # update chat history
println(resp.content)

# continue chatting
adduser!(chat, "How are you?")
next_resp = getresponse!(chat)
println(next_resp.content)

# fake response
adduser!(chat, "What's your name?")
addassistant!(chat, "My name is GPT-3.5.")

# print chat history
print(chat)
```

## License

This package is licensed under the MIT license. See the LICENSE file for more details.

## Features

* TODO
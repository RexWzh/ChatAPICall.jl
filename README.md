# ChatAPICall

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://RexWzh.github.io/ChatAPICall.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://RexWzh.github.io/ChatAPICall.jl/dev/)
[![Build Status](https://github.com/RexWzh/ChatAPICall.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/RexWzh/ChatAPICall.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/RexWzh/ChatAPICall.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/RexWzh/ChatAPICall.jl)

A simple wrapper for OpenAI's [API](https://platform.openai.com/docs/api-reference/introduction).


## Usage

### Set API Key

```julia
using ChatAPICall
ChatAPICall.apikey("sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
```

Or set `OPENAI_API_KEY` in `~/.bashrc` to automatically set it when you start the terminal:

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
resp = getresponse(chat, update=false) # Do not update the chat history, default is true
```

Example 2, customize the message template and return the information and the number of consumed tokens:

```julia
using ChatAPICall

# Customize the sending template
function ChatAPICall.default_prompt(msg)
    [
        Dict("role"=>"system", "content"=>"帮我翻译这段文字"),
        Dict("role"=>"user", "content"=>msg)
    ]
end

chat = Chat("Hello!")
# Set the number of retries to Inf
response = getresponse(chat, temperature=0.5, max_requests=Inf)
println("Number of consumed tokens: ", response.total_tokens)
println("Returned content: ", response.content)
```

### Advanced Usage

Continue chatting based on the last response:

```julia
# first call
chat = Chat("Hello, GPT-3.5!")
resp = getresponse(chat) # update chat history, default is true
println(resp.content)

# continue chatting
adduser!(chat, "How are you?")
next_resp = getresponse(chat)
println(next_resp.content)

# fake response
adduser!(chat, "What's your name?")
addassistant!(chat, "My name is GPT-3.5.")

# print chat history
printlog(chat)
```

## License

This package is licensed under the MIT license. See the LICENSE file for more details.

## Features

* TODO
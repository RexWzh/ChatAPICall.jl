
"""
    Resp

Response from OpenAI API.

# Fields

- `total_tokens::Int`: Total number of tokens in the response.
- `prompt_tokens::Int`: Number of tokens in the prompt.
- `completion_tokens::Int`: Number of tokens in the completion.
- `content::String`: The completion.
- `id::String`: The ID of the completion.
- `model::String`: The model used to generate the completion.
"""
struct Resp
    total_tokens::Int
    prompt_tokens::Int
    completion_tokens::Int
    content::String
    id::String
    model::String
end

"""
    ErrResp

Error response from OpenAI API.

# Fields

- `message::String`: The error message.
- `type::String`: The error type.
- `param::Union{Nothing, String}`: The parameter that caused the error.
- `code::String`: The error code.
"""
struct ErrResp
    message::String
    type::String
    param::Union{Nothing, String}
    code::String
end

function Resp(response::AbstractDict; compact::Bool=true)
    content = response["choices"][1]["message"]["content"]
    if compact
        content = strip(content)
    end
    return Resp(
        response["usage"]["total_tokens"],
        response["usage"]["prompt_tokens"],
        response["usage"]["completion_tokens"],
        content,
        response["id"],
        response["model"],
    )
end

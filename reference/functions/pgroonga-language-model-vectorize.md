---
title: pgroonga_language_model_vectorize function
upper_level: ../
---

# `pgroonga_language_model_vectorize` function

Since 4.0.5.

This is still an experimental feature.

## Summary

`pgroonga_language_model_vectorize` function returns a normalized embedding from the given text.

## Syntax

Here is the syntax of this function:

```text
float4[] pgroonga_language_model_vectorize(model_name, target)
```

`model_name` is the name of language model to be used. It's `text` type.

You can specify a Hugging Face URI for `model_name`.
we recommend using a Hugging Face URI, as it automatically downloads and sets up the model.
The model is saved in the PostgreSQL database's data directory.

The first time you run it, it will also download the model. Therefore, it will take some time.
For subsequent runs, the local model file that has already been downloaded will be used.

`target` is the input text. It's `text` type.

`pgroonga_language_model_vectorize` returns a normalized embedding (an array of `float4`).

## Usage

Here is an example of generating embeddings by specifying the Hugging Face URI (`hf:///groonga/all-MiniLM-L6-v2-Q4_K_M-GGUF`).

```sql
CREATE TABLE memos (
  content text
);

INSERT INTO memos VALUES ('I am a king.');
INSERT INTO memos VALUES ('I am a queen.');

SELECT (pgroonga_language_model_vectorize(
  'hf:///groonga/all-MiniLM-L6-v2-Q4_K_M-GGUF',
  content))[1:3]
FROM memos;

--    pgroonga_language_model_vectorize    
-- ----------------------------------------
--  {-0.027845971,0.04939433,-0.006889274}
--  {0.088152654,-0.027521685,0.051739622}
-- (2 rows)
```

Showing all embeddings would be too long, so only the first three are shown using `[1:3]`.

## See also

* [Groonga's `language_model_vectorize` function][groonga-language-model-vectorize]

[groonga-language-model-vectorize]:https://groonga.org/docs/reference/functions/language_model_vectorize.html

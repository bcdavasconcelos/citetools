# Cite Tools for Pandoc and Quarto

<!-- [![GitHub build status][CI badge]][CI workflow] -->

This extension bundles three Quarto/Pandoc filters (`multiple-bibliographies`, `citation-backlinks`, and `citefield`) to create a favorable environment for dealing with complex bibliography demands, producing output that works in any format supported by Pandoc (such as `HTML`, `DOCX` and `LaTeX`). 

## Features

More specifically, this bunddle seeks to address in the simplest of ways possible the following demands:

1. The need for multiple bibliographies (or bibliographies with multiple sections, such as `primary sources` and `secondary sources`).
2. The need to evoke arbitrary information from the references, such as `author`, `editor`, or `translator` names and `title` / `original-title` of works.
3. The need to turn the bibliography into a linked index of cited references, with links from the entries back to each of its multiple occurences in the body of the text (*e.g.* in PDF/DOCX: `[p. 1, p. 4, p. 10]`) (and with the ability to turn these off globally or in an *ad hoc* fashion).
- *Optionally*, the need to split the bibliography into sections, printing the bibliography for each chapter/section/part. (For this, you must uncomment the apropriate line in the `_extension.yaml` file.)

## Configuration

1. Install the extension in your project's folder using: `quarto install extension bcdavasconcelos/citetools`

2. Add citetools to the YAML header.

```yaml
---
filters:
  - citetools
---
```

3. Set up the bibliography files.


```yaml
---
bibliography_primary: refs/primary.json
bibliography_secondary: refs/secondary.json
---
```

4. Then, place the bibliographies placeholders in the document where you want the bibliographies to appear.

``` markdown
# References

::: {#refs-primary}
:::

# Software

::: {#refs-secondary}
:::
```

Each refs-*x* div should have a matching entry *x* in the
metadata. These divs are filled with citations from the respective
bib-file.

**IMPORTANT: make sure the bibliography names and the placeholder divs match. That is, if you have a bibliography named `bibliography_primary`, then the placeholder div should be `refs-primary` or `refs_primary`.**

### Global options

Global meta data options:

- `link-fields` (boolean): Whether to link fields to their respective bibliographic entry. Default: `true`.
- `link-citations` (boolean): Whether to link citations to their respective bibliographic entry. Default: `true`.


See sample document `sample.qmd` for a working example with explanations.


Usage
------------------------------------------------------------------

The filter modifies the internal document representation; it can
be used with many publishing systems that are based on pandoc.

## Quarto

Users of Quarto can install this filter as an extension with

    quarto install extension bcdavasconcelos/citetools

and use it by adding `citetools` to the `filters` entry
in their YAML header.

``` yaml
---
filters:
  - citetools
---
```

### R Markdown

Use `pandoc_args` to invoke the filter. See the [R Markdown
Cookbook](https://bookdown.org/yihui/rmarkdown-cookbook/lua-filters.html)
for details.

``` yaml
---
output:
  word_document:
    pandoc_args: ['--lua-filter=citetools']
---
```


<img width="665" alt="image" src="https://user-images.githubusercontent.com/35749099/226091195-7b27f8a7-c802-4cbb-bac9-81265b7aed45.png">


License
------------------------------------------------------------------
The filters bundled in this extension were published under the MIT license by Albert Krewinkel (a.k.a. `tarleb`) and modified by Bernardo CDA Vasconcelos (a.k.a. `bcdavasconcelos`).

These pandoc Lua filter are published under the MIT license, see
file `LICENSE` for details.




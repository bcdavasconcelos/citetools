# citetools

[![GitHub build status][CI badge]][CI workflow]

This extension bundles three Quarto/Pandoc filters to create a favorable environment for dealing with complex bibliography demands with *Citeproc* in order to work both for `HTML` and `LaTeX` output. The filters are called `multiple-bibliographies`, `citation-backlinks`, and `citefield`.


Examples of such demands are:

- The need for multiple bibliographies (or bibliographies with multiple sections, such as `primary sources` and `secondary sources`).
- The need for linked indices of cited references that work for `LaTeX` and `HTML`; that is, the ability to link citations to their respective bibliographic entry, and back from the entry to each citation in the text, like so: `[1, 2, 3]`.
- The need to evoke arbitrary information from the references, such as `author`, `editor`, or `translator` names and `title` / `original-title` of works. 
  - Do that linking the field content being displayed inline *to* the entry in the bibliography.
  - And *back* from the entry to its multiple occurrences in the text.
- The ability to turn off these links and backlinks globally or in an *ad hoc* fashion.


## Configurations

Set up the bibliography files in the YAML header of your document.


```yaml
---
bibliography_primary: refs/primary.json
bibliography_secondary: refs/secondary.json
---
```

Then, place the bibliographies placeholders in the document where you want the bibliographies to appear.

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

Important: make sure the bibliography names and the placeholder divs match. That is, if you have a bibliography named `bibliography_primary`, then the placeholder div should be `refs-primary`.

## Usage

Global meta data options:

- `bibliography_NAME` (string): Path to the primary bibliography file.
- `link-fields` (boolean): Whether to link fields to their respective bibliographic entry. Default: `true`.
- `link-citations` (boolean): Whether to link citations to their respective bibliographic entry. Default: `true`.


See sample document `sample.qmd` for a working example with explanations.


Usage
------------------------------------------------------------------

The filter modifies the internal document representation; it can
be used with many publishing systems that are based on pandoc.

### Plain pandoc

Pass the filter to pandoc via the `--lua-filter` (or `-L`) command
line option.

    pandoc --lua-filter citetools.lua ...

### Quarto

Users of Quarto can install this filter as an extension with

    quarto install extension pandoc-ext/citetools

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
    pandoc_args: ['--lua-filter=citetools.lua']
---
```

License
------------------------------------------------------------------
The filters bundled in this extension were published under the MIT license by Albert Krewinkel (a.k.a. `tarleb`) and modified by Bernardo CDA Vasconcelos (a.k.a. `bcdavasconcelos`).

These pandoc Lua filter are published under the MIT license, see
file `LICENSE` for details.

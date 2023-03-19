# 📚 Cite Tools for Pandoc and Quarto 

<div id="top"></div>

<!-- [![GitHub build status][CI badge]][CI workflow] -->

This extension introduces advanced bibliography features to Pandoc and Quarto's Citeproc environment. It bundles several Lua filters ([*vide infra*](#license)) to address complex bibliography demands while keeping the output consistent across all formats (`LaTeX`, `DOCX`, `HTML`, and so on).

## Features


More specifically, this bunddle seeks to address in the simplest of ways possible the following demands:

**1. Multiple bibliographies**

The need for multiple bibliographies (or bibliographies with multiple sections, such as `primary sources` and `secondary sources`).

![](2023-03-18-22-02-26.png)

**2. Cite fields**

The need to evoke arbitrary information from the references, such as `author`, `editor`, or `translator` names and `title` / `original-title` of works.

![](2023-03-18-22-24-10.png)

<details>
  <summary>`@AristOp` in `csljson`</summary>

```json
{
    "author": [
      {
        "family": "Aristotle"
      }
    ],
    "editor": [
      {
        "family": "Bekker",
        "given": "Immanuel"
      }
    ],
    "id": "AristOp",
    "issued": {
      "date-parts": [
        [
          1831
        ]
      ]
    },
    "number-of-volumes": "4",
    "publisher": "Reimer",
    "publisher-place": "Berlim",
    "title": "Aristotelis opera",
    "type": "book"
  }
```

</details>

**3. Citation backlinks**

The need to turn the bibliography into a linked index of cited references, with links from the entries back to each of its multiple occurences in the body of the text (*e.g.* in `PDF`/`DOCX`: `[p. 1, p. 4, p. 10]`, in `HTML`: `[1, 2, 3]`) (and with the ability to turn these off globally or in an *ad hoc* fashion).

![](2023-03-18-22-32-06.png)

- *Optionally*, the need to split the bibliography into sections, printing the bibliography for each chapter/section/part. (For this, you must uncomment the apropriate line in the `_extension.yaml` file.)

## Install

Users of Quarto can install this extension with the following command

```bash
quarto install extension bcdavasconcelos/citetools
```

and use it by adding `citetools` to the `filters` entry in their YAML header.

``` yaml
---
filters:
  - citetools
---
```

## Configuration

### Multiple bibliographies

Add bibliography files to the `refs` folder. Then, add the following metadata to the YAML header of your document in this way:

```yaml
---
bibliography_primary: refs/primary.json
bibliography_secondary: refs/secondary.json
---
```

Then, place the bibliographies placeholders in the document where you want the bibliographies to appear.

``` markdown
# Primary Sources

::: {#refs_primary}
:::

# Secondary Sources

::: {#refs_secondary}
:::
```

These divs are filled with citations from the respective bib-file. Each refs-*x* div should have a matching entry *x* in the metadata.

**Make sure the bibliography name and the placeholder div id match.**

That is, if you have a bibliography named `bibliography_primary`, the placeholder div should be `refs-primary` or `refs_primary`.

### Cite fields and citation backlinks global options

- `link-fields` (boolean): Link inlines printed by `citefield` to their corresponding entry in the bibliography. Default: `true`.
- `link-citations` (boolean): Link citations to their respective reference in the bibliography. Default: `true`. Note: if `link-citations` is set to `false`, `link-fields` is also set to `false`.

---

See sample document `sample.qmd` for a working example with explanations.


<img width="665" alt="image" src="https://user-images.githubusercontent.com/35749099/226091195-7b27f8a7-c802-4cbb-bac9-81265b7aed45.png">


License
------------------------------------------------------------------
Filters published under the MIT license by Albert Krewinkel ([tarleb](https://github.com/tarleb)).

- [multibib](https://github.com/pandoc-ext/multibib)
- [multiple-bibliographies](https://github.com/pandoc/lua-filters/tree/master/multiple-bibliographies)
- [citation-backlinks](https://github.com/bcdavasconcelos/citation-backlinks)
- [section-bibliographies](https://github.com/pandoc-ext/section-bibliographies)

Filters published under the MIT license by Albert Krewinkel ([tarleb](https://github.com/tarleb)) & Bernardo Vasconcelos ([bcdavasconcelos](https://github.com/bcdavasconcelos)).

- [citefield](https://github.com/bcdavasconcelos/citefield)


All Pandoc Lua filters in this extension are published under the MIT license, see
file `LICENSE` for details.

[Back to top](#top)

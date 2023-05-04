--- https://github.com/bcdavasconcelos/citefield
--- citefield.lua
--- 1.0.3
--- Copyright: © 2023 - Albert Krewinkel & Bernardo Vasconcelos
--- License: MIT – see LICENSE for details

--- [@Citekey]{.csl_field}
--- to print any valid CSL field
--- [@Citekey]{.csl_field.} (with extra dot)
--- to do it without creating a link.

--- ATTENTION: *MUST* *RUN* *AFTER* *CITEPROC*.

PANDOC_VERSION:must_be_at_least '2.17'

local stringify = require 'pandoc.utils'.stringify

csl_fields = {"abstract", "accessed", "annote", "archive", "archive_collection", "archive_location", "archive-place", "author", "authority", "available-date", "call-number", "chair", "chapter-number", "citation-key", "citation-label", "citation-number", "collection-editor", "collection-number", "collection-title", "compiler", "composer", "container-author", "container-title", "container-title-short", "contributor", "curator", "dimensions", "director", "division", "DOI", "edition", "editor", "editor-translator", "editorial-director", "event", "event-date", "event-place", "event-title", "executive-producer", "first-reference-note-number", "genre", "guest", "host", "illustrator", "interviewer", "ISBN", "ISSN", "issue", "issued", "jurisdiction", "keyword", "language", "license", "locator", "medium", "narrator", "note", "number", "number-of-pages", "number-of-volumes", "organizer", "original-author", "original-date", "original-publisher", "original-publisher-place", "original-title", "page", "page-first", "part-number", "part-title", "performer", "PMCID", "PMID", "printing-number", "producer", "publisher", "publisher-place", "recipient", "references", "reviewed-author", "reviewed-genre", "reviewed-title", "scale", "script-writer", "section", "series-creator", "source", "status", "submitted", "supplement-number", "title", "title-short", "translator", "URL", "version", "volume", "volume-title", "year-suffix"}

function get_options(meta)
  if meta['link-citations'] or meta['link-fields'] or meta['title-field-emphasis'] then
      return {link_citations = meta['link-citations'], link_fields = meta['link-fields'], title_field_emph = meta['title-field-emphasis']}
  else
      return {}
  end
end

local function has_value(tab, val)
  for index, value in ipairs(tab) do
      if value == val then
          return true
      end
  end
  return false
end

function Pandoc (doc)

  doc.meta.references = pandoc.utils.references(doc)
  doc.meta.bibliography = nil

  return doc:walk{

    Span = function (span)

      -- check that the span contains only a single cite object
      local cite = span.content[1]
      local citations = cite and cite.citations or nil
      if #span.content == 1 and cite.t == 'Cite' and #citations == 1 then
        the_arg = stringify(span.classes[1])
        if span.classes[2] then -- note in use
          local extra_arg = stringify(span.classes[2])
        end
      -- check dotted to turn off linking
      if string.find(the_arg, ".", 1, true) then
        dotted = true
        the_arg = string.gsub(the_arg, "%.$", "")
        else
          dotted = false
      end
      -- check ordinal:to retrieve the first, second, third or forth author/editor/translator
      if string.find(the_arg, "_first", 1, true) then
        ordinal = 1
        the_arg = string.gsub(the_arg, "%_first$", "")
        else if string.find(the_arg, "_second", 1, true) then
          ordinal = 2
          the_arg = string.gsub(the_arg, "%_second$", "")
          else if string.find(the_arg, "_third", 1, true) then
            ordinal = 3
            the_arg = string.gsub(the_arg, "%_third$", "")
            else if string.find(the_arg, "_forth", 1, true) then
              ordinal = 4
              the_arg = string.gsub(the_arg, "%_fourth$", "")
              else
                ordinal = 1
              end
            end
          end
      end

      -- Simple error trap
      if has_value(csl_fields, the_arg) then
        else -- if field is not valid
          return "#ERROR: Invalid CSL Field#"
      end -- end of error trap

      local cite_id = citations[1].id -- get citekey
      local the_result = "" -- initialize result
      local ref = doc.meta.references:find_if( -- get reference
      function (r) return cite_id == r.id end
    ) -- end of get reference

      if ref and ref[the_arg] then -- if field is not empty
        local content = ref[the_arg] -- get field
        local title_field_emph = get_options(doc.meta).title_field_emph
        if the_arg == "author" or the_arg == "editor" or the_arg == "translator" then -- if field contains name
          if content[ordinal] then -- if name[ord] exists
            if content[ordinal]["family"] then -- if name[ord] contains family name
              the_result = ref[the_arg][ordinal]["family"] -- get family name
              else if ref[the_arg][ordinal]["literal"] then -- if name[ord] does not contain family name, but contains literal
                the_result = ref[the_arg][ordinal]["literal"]
              else -- if field does not contain family name or literal
                the_result = "#ERROR#"
              end
            end -- end of name exists
          else -- no name error
            print("ERROR: [".. cite_id .. "][" .. the_arg .. "][" .. ordinal .. "] is empty")
            return "#ERROR: [".. cite_id .. "][" .. the_arg .. "][" .. ordinal .. "] is empty#"
          end -- end of field contains name
        else if the_arg == "title" and title_field_emph ~= false then -- if field is a title
            the_result = pandoc.Emph{stringify(ref[the_arg])}
          else if the_arg == "title-short" and title_field_emph ~= false then -- if field is a short title
              the_result = pandoc.Emph{stringify(ref[the_arg])}
            else -- if field is not a name or a title
              the_result = stringify(ref[the_arg])
            end -- end of field is not a name or a title
          end -- end of field is a short title
        end -- end of field is a title
      else -- end of field is empty
        the_result = span
      end

      if dotted == true
      or the_arg == "notes"
      or the_arg == "abstract"
      or the_arg == "keyword"
      or the_arg == "annote"
      or get_options(doc.meta).link_citations == false
      then -- if field is not to be linked
        return the_result
      else -- if field is to be linked
        if get_options(doc.meta).link_citations == true and get_options(doc.meta).link_fields ~= false then
          the_result = pandoc.Link(the_result, "#ref-"..cite_id)
          cite.content = {the_result}
          return cite
        else -- if get_options(doc.meta).link_citations == true and get_options(doc.meta).link_fields == false then
          return the_result
        end
      end -- end of field is to be linked
    end -- end of span contains only a single cite object

  end -- end of Span

  } -- end of doc:walk

end -- end of Pandoc


--- The original version of this script was generously contributed by [Albert Krewinkel](https://github.com/sponsors/tarleb) to the [Pandoc-Dicuss mailing list](https://groups.google.com/g/pandoc-discuss/c/5gb64T4OU9Q). It is being shared with permission (and at the request) of the original author for the benefit of the community of Pandoc users.
--- The current version was butchered by Bernardo CDA Vasconcelos to include error msgs, csl-field validation, making all field retrievable (including items in lists), adding emph for titles. The code probably needs refactorying from someone that actually know something about Lua to make it simpler, but it works.

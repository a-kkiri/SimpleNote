/*
  Keep track of a running note counter, and associated notes.
*/

#let note_state_prefix = "notes-"
#let note_default_group = "default"

#let note_default_display_fn(note) = {
  h(0pt, weak: true)
  super([<#note.index>])
}

#let add_note(
  // The location of the note. This is used to derive
  // what the note counter should be for this note.
  loc,
  // The note itself.
  text,
  // The offset which will be added to the 0-based counter index
  // when the index stored in the state.
  offset: 1,
  // the display function that creates the returned content from put.
  // Put can't return a pure index number because the counter
  // and state updates need to output content.
  display: note_default_display_fn,
  // The state group to track notes in.
  // A group acts independent (both counter and set of notes)
  // from other groups.
  group: note_default_group
) = {
  let s = state(note_state_prefix + group, ())
  let c = counter(note_state_prefix + group)
  // find any existing note that hasn't been printed yet,
  // containing the exact same text:
  let existing = s.at(loc).filter((n) => n.text == text)
  // If we found an existing note use that,
  // otherwise the note is the current location's counter + offset
  // and the given text (the counter is 0-based, we want 1-based indices)
  let note = if existing.len() > 0 {
    existing.first()
  } else {
    (text: text, index: c.at(loc).first() + offset, page: loc.page())
  }

  // If we didn't find an existing index, increment the counter
  // and add the note to the "notes" state.
  if existing.len() == 0 {
    c.step()
    s.update(notes => notes + (note,))
  }
  
  // Output the note marker
  display(note)
}

// get notes at specific location
#let get_notes(loc, group: note_default_group) = {
  state(note_state_prefix + group, ()).at(loc)
}

// Reset the note group to empty.
// Note: The counter does not reset by default.
#let reset_notes(group: note_default_group, reset_counter: false) = {
  if reset_counter {
    counter(note_state_prefix + group).update(0)
  }
  state(note_state_prefix + group, ()).update(())
}

//
// Helpers for nicer in-document ergonomics
//

#let render_notes(fn, group: note_default_group, reset: true, reset_counter: false) = {
  locate(loc => fn(get_notes(loc, group: group)))
  if reset {
    reset_notes(group: group, reset_counter: reset_counter)
  }
}

// Create a new note at the current location
#let note(note, ..args) = {
  locate((loc) => add_note(loc, note, ..args))
}

// The quick-start option that outputs something useful by default.
// This is a sane-defaults call to `render_notes`.
#let notes(
  size: 8pt,
  line: line(length: 106%, stroke: 1pt + gray),
  padding: (top: 0mm),
  alignment: left + top,
  numberings: "1",
  group: note_default_group,
  reset: true,
  reset_counter: false
) = {
  let render(notes) = {
    if notes.len() > 0 {
      set align(alignment)
      block(breakable: false, pad(..padding, {
        if line != none { align(center)[#line] }
        set text(size: size)
        for note in notes {
          [/ #text()[<#numbering(numberings, note.index)>]: #note.text #v(-1pt)]
        }
      }))
    }
  }
  render_notes(group: group, reset: reset, reset_counter: reset_counter, render)
}
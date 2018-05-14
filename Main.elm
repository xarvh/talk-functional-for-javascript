module Main exposing (..)

import Slides exposing (..)


main =
    Slides.app
        slidesDefaultOptions
        [ md
            """
            # Functional Programming for JavaScript
            """
        , md
            -- "Adslot is a marketplace for online advertisement..."
            -- There is one start/end datepicker for each line item
            -- There is a main start/end datepicker
            """
            [image:
              * main datepicker
              * line item 1 datepicker
              * line item 2 datepicker
              * line item 3 datepicker
              * ...
            ]
            """
        , md
            """
            [image: datepicker}

            * `getDates()`
            * `setDates()`
            * `onDateChange()`

            -> In OOP the internal state is *inaccessible*
            """
        , md
            -- We can get an idea of the flow of state update calls
            -- It looks simple enough
            -- Many things had to change when a date changed, some sync and some async (availability, costs...)
            """
            [image:
              * main datepicker
                A |
                | |
                | V
              * line item 1 datepicker
              * line item 2 datepicker
              * line item 3 datepicker
              * ...
            ]
            """
        , md
            -- We could not keep the datepickers in sync
            -- Felt like a Whac-a-mole
            """
            [image:
              * main datepicker WITH HIGHLIGHTED WRONG DATE
              * line item 1 datepicker
              * line item 2 datepicker
              * line item 3 datepicker
              * ...
            ]
            """
        , md
            """
            [ Facebook page, with messages counter highlighted ]
            """
        , md
            """
            The problem: Keep consistency **across** Objects
            -> The network of update calls is unmaintainable
            """
        , md
            """
            What is "state"?
            -> *Anything* that can change in our application
            OR
            -> The collection of all the mutable information we need to render the page
            """

        , md
            -- So what's the state for our page?
            -- There is more information than we need!
            """
            [image:
              * main datepicker `start: 2011-01-01, end: 2011-02-02`
              * line item 1 datepicker `start: 2011-01-01, end: 2011-02-02`
              * line item 2 datepicker `start: 2011-01-01, end: 2011-02-02`
              * line item 3 datepicker `start: 2011-01-01, end: 2011-02-02`
              * ...
            ]
            """
        , md
            """
            [image:
              * ~~main datepicker `start: 2011-01-01, end: 2011-02-02`~~~
              * line item 1 datepicker `start: 2011-01-01, end: 2011-02-02`
              * line item 2 datepicker `start: 2011-01-01, end: 2011-02-02`
              * line item 3 datepicker `start: 2011-01-01, end: 2011-02-02`
              * ...
            ]

            -> We *CANNOT* do this in OOP
            """
        , md
            """
            ```
            lineItem: [
              { id: 1, start: 2011-01-01, end: 2011-02-02 }
              { id: 2, start: 2011-01-01, end: 2011-02-02 }
              ...
            ]

            renderDatepicker({
              startDate: minOf(lineitems, "start"),
              endDate: maxOf(lineitems, "end"),
              onChange: (start, end) => clampAllLineItems(start, end),
            })
            ```
            -> It is *slower*, because we recalculate that min, max **every** time
            -> Our state CANNOT express an inconsistecy between main and lineitems
            -> The best test is the test you don't have to write
            """
        , md
            """
            ```
            mainDatePickerIsOpen: false,
            lineItems: [
              { id: 1, start: 2011-01-01, end: 2011-02-02, isOpen: false }
              { id: 2, start: 2011-01-01, end: 2011-02-02, isOpen: true }
              { id: 3, start: 2011-01-01, end: 2011-02-02, isOpen: false }
              ...
            ]
            ```
            -> This model can represent two open datepickers
            """
        , md
            """
            ```
            openDatepicker: "lineitem 2",
            lineItems: [
              { id: 1, start: 2011-01-01, end: 2011-02-02 }
              { id: 2, start: 2011-01-01, end: 2011-02-02 }
              { id: 3, start: 2011-01-01, end: 2011-02-02 }
              ...
            ]
            ```
            -> Opening a datepicker *inherently* closes all others
            -> **We make unwanted states impossible**
            """
        , md
            -- We don't need to test for loss of consistency
            -- In fact, we CAN'T even test for it!
            """
            ```jsx
            <Datepicker {...{
              startDate: minOf(this.lineitems, "start"),
              endDate: maxOf(this.lineitems, "end"),
              isOpen: openDatepicker === "main",
              onChange: (start, end) => this.clampAllLineItems(start, end),
            }} />
            ```
            -> We **can't** even test the state update f for loss of consistency
            -> (We can test it in the render f, and that's trivial)
            """
        , md
            """
            Rules of thumb:
            -> Don't extract state unnecessarily
            -> Do it if it allows to make unwanted states impossible
            -> Do it if it needs to be accessed by the parent component
            """
        , md
            -- FIRST we model the state, THEN we think about render and update
            """
            ## Make Unwanted States Impossible

            -> **Model first**
            -> This makes sense only with a Virtual Dom like React
            -> ML types and static type check allow to crank this technique up to 11
            """
        , md
            """



            (We're half way. Questions so far?)



            """
        , md
            """
            [image: lineitem datepicker object <=> main date picker object ]

            -> Objects form a network of interactions that can have loops
            -> It's difficult to think about, and difficult to maintain
            """
        , md
            """
            -> A pure function is a uni-directional pipe

            [image: input -> ]==function==[ -> output]

            All that matters is what goes in, and what gets out.

            **Nothing else can affect it or be affected by it.**

            -> When you assemble together pure functions, it's very easy to follow the flow
            """
        , md
            -- a reducer is a fancy name for a function that takes the old state and produces a new state
            """
            [image
              external events + oldState
                |
                V
              ]=="reducer"==[ <--- split in many functions
                |
                V
              new state + side effects
                |
                V
              ]==render==[ <--- also split in many functions
                |
                V
                DOM -> external events
            """
        ]


x =
    """
  -> Producing every time an entirely new state is definitely a drawback, but the advantages are worth it, and it’s why everything is moving in that direction
  -> Sometimes it's ok to have stateful components
  -> Often the state is so simple that it's not worth to extract it and involve Redux and all its boilerplate


  -> Use pipes instead of webs







#

  [ messages from the world + oldState -> "reducer" function (broken in sub-functions) ->  newState -> render functions -> Html the user can interact with ]
  -> pure functions form a unidirectional assembly of pipes

  ^ This is advantage #1 of "purity" and immutability: it's really easy to follow the flow


#
  Advantage #2: testing


#
  There are other advantages, but they don't really apply to js
    * reference comparison
    * caching
    * concurrency


#
  Disadvantages
    * modifying state is a lot more complicated
    * raw computation can often be less efficient
      (but in the FE it is more important to render efficiently)



Union types: crocus questions
Union type: loading, error, available
"""

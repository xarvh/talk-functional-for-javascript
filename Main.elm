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

        {-
           , md
               """
               The "model" is the collection of data structures
               that we use to represent the state.
               ```
               // datepicker model

               ```
               """
        -}
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

            renderDatepicker(min(lineitems, 'start'), max(lineitems, 'end'), changeAll)
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
            ## Make Unwanted States Impossible
            -> We **can't** even test for loss of consistency
            -> (We can test it in the render f, and that's trivial)
            -> First we model the state, *then* we write the code to render it
            -> Code our interfaces --> *Model first* <--
            -> This makes sense only with a Virtual Dom like React
            -> ML types and static type check allow to crank this technique up to 11
            """

        , md
            """
            ---------




            Break

            (Questions?)




            ---------
            """


        ]


x =
    """
#
  “How do we update the state?”
  -> with “reducers” (which is a fancy name for update functions)
  -> In the example above, how do we test that the main datepicker stays consistent?
  -> The best test is the one you don’t have to write
  -> Producing every time an entirely new state is definitely a drawback, but the advantages are worth it, and it’s why everything is moving in that direction


#
  “How do we generate side effects?”
  -> This is an open problem in JS, it depends on many things and there doesn’t seem to be a consensus
  -> Have the reducer return a function with the side effect
  -> This will help with testing



#
  -> Sometimes it's ok to have stateful components
  -> Often the state is so simple that it's not worth to extract it and involve Redux and all its boilerplate


  -> Use pipes instead of webs







#
  [ line item date picker object <=> main date picker object ]
  -> Objects form a network of interactions that can have loops

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

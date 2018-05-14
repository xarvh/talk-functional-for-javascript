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
            """
            [image:
              * main datepicker `start: 2011-01-01, end: 2011-02-02`
              * line item 1 datepicker `start: 2011-01-01, end: 2011-02-02`
              * line item 2 datepicker `start: 2011-01-01, end: 2011-02-02`
              * line item 3 datepicker `start: 2011-01-01, end: 2011-02-02`
              * ...
            ]
            """
        ]


x =
    """

#
  [ main datepicker + line item date pickers, each with their state ]
  -> redundant information
  -> more stuff to update
  -> more things  that can go wrong


#
  [ main datepicker crossed in red, lineitem datepicker state only ]
  -> Our variables CANNOT describe an unwanted state








#
  [ datepicker with status: startDate, endDate, isOpen ]
  "Datepickers can be open or closed, so it makes sense that to our state we also
  add another variable to track whether the datepicker is open or closed"


#
  [ page bloated with too many open datepickers ]
  [ datepicker statuses with many isOpen = True ]
  "To keep the page tidy, a UI convention is that only one dropdown should be open at the time
  But our model allows many of them to be open together."


#
  [ page with a single datepicker open]
  [ list of (startDate, endDate) and single openDatePickerId variable ]
  [ list of datepickers, with isOpen=datepickerId(lineItem) === this.state.openDatepickerId ]

  lineItems.map(lineItem => renderDatepicker({
       startDate: lineItem.startDate,
       endDate: lineItem.endDate,
       isOpen, datepickerId(lineItem) === this.state.openDatepickerId,
       onChange: (startDate, endDate) => **set**(lineItem.id, startDate, endDate),
       onToggle: isOpen => this.setState({ openDatepickerId: isOpen? datepickerId(lineItem) : null }))

  -> The model makes it *impossible* for more than one datepicker to be open at the same time.
  -> Opening a datepicker *inherently* closes all others
  -> When we test the state manipulation functions, we CANNOT EVEN TEST whether multiple datepickers will be open
  -> (we can test it in the view tho)
  -> The best test is the one you don’t have to write
  -> We aren’t even using functional for the state

#
  -> We make unwanted states *impossible*
  -> First we model the state, *then* we write the code to render it
  -> Code our interfaces --> *Model first* <--
  -> ML types and static type checking allow to crank this technique up to 11


#
  "So how do we turn that state into something that the browser can render?"
  [ renderFunction(startDate, endDate, onChangeCallback) ]
  -> We can do this because React ensures that ALL information is
    reconsidered at EVERY render
  -> Testing the Object would require us to create a full Object (which might require a lot of stuff)
  -> if renderFunction is a pure function, it’s really easy to test


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

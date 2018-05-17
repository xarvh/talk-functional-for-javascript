module Main exposing (..)

import Css exposing (..)
import Css.Elements exposing (..)
import Slides exposing (..)
import Slides.FragmentAnimation as FA
import Slides.SlideAnimation as SA


blur completion =
    "blur(" ++ (toString <| Basics.round <| (1 - completion) * 10) ++ "px)"


verticalDeck : SA.Animator
verticalDeck status =
    Css.asPairs <|
        case status of
            SA.Still ->
                [ Css.position Css.absolute
                ]

            SA.Moving direction order completion ->
                case order of
                    SA.LaterSlide ->
                        [ Css.position Css.absolute
                        , Css.property "z-index" "1"
                        , Css.property "filter" (blur completion)
                        , Css.property "-webkit-filter" (blur completion)
                        ]

                    SA.EarlierSlide ->
                        [ Css.position Css.absolute
                        , Css.transform <| Css.translate2 zero (pct (completion * 100))
                        , Css.property "z-index" "2"
                        ]


betterFade : FA.Animator
betterFade completion =
    Css.asPairs
        [ Css.opacity (Css.num completion)
        , Css.property "filter" (blur completion)
        , Css.property "-webkit-filter" (blur completion)
        ]


font =
    px 20


bgColor =
    rgb 255 255 255


codeBgColor =
    rgb 230 230 230


txtColor =
    hex "60B5CC"


elmBlueOnWhite : List Css.Snippet
elmBlueOnWhite =
    [ body
        [ padding zero
        , margin zero
        , height (pct 100)
        , backgroundColor bgColor
        , color txtColor
        , fontFamilies [ "calibri", "sans-serif" ]
        , fontSize font
        , fontWeight bold
        ]
    , h1
        [ fontSize (px 38)
        , fontWeight bold
        ]
    , section
        [ height (px 700)
        , width (pct 100)
        , backgroundColor bgColor
        , property "background-position" "center"
        , property "background-size" "cover"
        , displayFlex
        , property "justify-content" "center"
        , alignItems center
        ]
    , Css.class "slide-content"
        [ margin2 zero (px 90)
        ]
    , code
        [ textAlign left
        , fontSize font
        , backgroundColor codeBgColor
        ]
    , Css.Elements.pre
        [ padding (px 20)
        , fontSize font
        , backgroundColor codeBgColor
        ]
    , img
        [ width (pct 100)
        ]
    ]


main =
    Slides.app
        { slidesDefaultOptions
            | style = elmBlueOnWhite
            , slideAnimator = verticalDeck
            , fragmentAnimator = betterFade
        }
        [ md
            """
            # Making unwanted states impossible
            """
        , md
            -- "Adslot is a marketplace for online advertisement..."
            -- There is one start/end datepicker for each line item
            -- There is a main start/end datepicker
            """
            ![asp](images/advertiser-selection-page.svg)
            """
        , md
            """
            ![datepicker](images/single-datepicker.svg)

            * `getDates()`
            * `setDates()`
            * `onDateChange()`

            ➡ In OOP the internal variables are *inaccessible*
            """
        , md
            -- We can get an idea of the flow of state update calls
            -- It looks simple enough
            -- Many things had to change when a date changed, some sync and some async (availability, costs...)
            """
            ![oop update flow](images/oop-update-flow.svg)
            """
        , md
            -- We could not keep the datepickers in sync
            -- Felt like a Whac-a-mole
            """
            ![inconsistency](images/inconsistency.svg)
            """
        , md
            """
            ![fb](images/fb.svg)
            """
        , md
            """
            The problem: Keep consistency *across* Objects

            ➡ The network of update calls is unmaintainable
            """
        , md
            """
            What is "state"?

            ➡ *Anything* that can change in our application without changing your source code

            OR

            ➡ The collection of all the mutable information we need to render the page
            """
        , md
            -- So what's the state for our page?
            -- There is more information than we need!
            """
            # State comes first

            * main: `start: 2011-01-01, end: 2011-02-02`
            * lineItem1: `start: 2011-01-01, end: 2011-02-02`
            * lineItem2: `start: 2011-01-01, end: 2011-02-02`
            * lineItem3: `start: 2011-01-01, end: 2011-02-02`
            * ...

            ➡ *What* vs *How*

            ➡ We define the problem in terms of the app state
            """
        , md
            """
            * ~~main: `start: 2011-01-01, end: 2011-02-02`~~
            * lineItem1: `start: 2011-01-01, end: 2011-02-02`
            * lineItem2: `start: 2011-01-01, end: 2011-02-02`
            * lineItem3: `start: 2011-01-01, end: 2011-02-02`
            * ...

            ➡ Is this enough info to display all that we want to display?

            ➡ This is NOT how OOP works!
            """
        , md
            """
            ```javascript
            lineItems: [
              { id: 1, start: 2011-01-01, end: 2011-02-02 }
              { id: 2, start: 2011-01-01, end: 2011-02-02 }
              ...
            ]

            ```
            ➡ Our state CANNOT express the inconsistency!
            """
        , md
            """
            ```javascript
            // Render line item datepickers
            lineItems.map lineItem => renderDatepicker({
              startDate: lineItem.start
              endDate: lineItem.end
              onChange: (start, end) => setLineItem(lineItem.id, start, end),
            })

            renderDatepicker({
              startDate: minOf(lineitems, "start"),
              endDate: maxOf(lineitems, "end"),
              onChange: (start, end) => clampAllLineItems(start, end),
            })
            ```

            ➡ How do you test for loss of consistency?

            ➡ State update becomes an atomic operation
            """
        , md
            """
            ➡ This requires a Virtual Dom like React

            ➡ In OOP, the Object decides when to rerender

            ➡ In React, React does

            ➡ React removes the responsibility of rendering from the Object
            """
        , md
            """
            ```javascript
            mainDatePickerIsOpen: false,
            lineItems: [
              { id: 1, start: 2011-01-01, end: 2011-02-02, isOpen: false }
              { id: 2, start: 2011-01-01, end: 2011-02-02, isOpen: true }
              { id: 3, start: 2011-01-01, end: 2011-02-02, isOpen: false }
              ...
            ]
            ```
            ➡ This model can represent two open datepickers
            """
        , md
            """
            ```javascript
            openDatepicker: "lineitem 2",
            lineItems: [
              { id: 1, start: 2011-01-01, end: 2011-02-02 }
              { id: 2, start: 2011-01-01, end: 2011-02-02 }
              { id: 3, start: 2011-01-01, end: 2011-02-02 }
              ...
            ]
            ```
            """
        , md
            -- We don't need to test for loss of consistency
            -- In fact, we CAN'T even test for it!
            """
            ```javascript
            <Datepicker {...{
              startDate: minOf(this.state.lineitems, "start"),
              endDate: maxOf(this.state.lineitems, "end"),
              isOpen: this.state.openDatepicker === "main",
              onOpen: () => this.setState({ openDatepicker: "main" }),
              onClose: () => this.setState({ openDatepicker: null }),
              onChange: (start, end) => this.clampAllLineItems(start, end),
            }} />
            ```
            ➡ The act of opening a dropdown **closes all others**
            """
        , md
            """
            Rules of thumb:

            ➡ Don't extract state unnecessarily

            ➡ Do it if it allows to make unwanted states impossible

            ➡ Do it if it needs to be accessed by the parent component

            """
        , md
            -- FIRST we model the state, THEN we think about render and update
            """
            ➡ **Model first**

            ➡ A good model helps *thinking* about the problem!
            """
        , md
            """
            ➡ ML types and static type check allow to crank this technique up to 11

            ➡ YouTube: Richard Feldman "Making impossible states impossible"
            """
        , md
            """
            # Done!
            """
        ]



{-
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
-}

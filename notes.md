

#
 Functional programming for javascript


#
  [ main datepicker + line item date pickers ]

  "Adslot is a marketplace to buy and sell online advertisement space.

  The super simplified version is that the advertiser can see the banners
  available for a certain page and for each banner that they want to book they
  can select a booking start and end date.

  This meant that each banner had a start/end datepicker.
  We also had a "main" datepicker, that showed, and allowed to change, the
  earliest start and latest end dates for the whole campaign.


#
 fragments:

  * [image datepicker]
  "A date picker is a very common UI element"

  "A core idea of Object Oriented Programming each object is entirely responsible for
  manipulating its own state: the outside world should not be able to
  directly change or even see the state.
  Instead the Object should expose methods that allow to safely manipulate
  and read the state."

  * datepicker methods: getDates, setDates, setDateChangeCallback
  "According to this idea, we could model the datepicker as an Object that exposes
  three methods."


#
  [ main datepicker + line item date pickers, each with their methods ]

  "So how do we go to set this?
  When a line item datepicker changes, then the general should be updated.
  When the general datepicker changes, all the line item ones should be updated.
  We can get an idea of the flow of the update calls."

  "In reality the flow was a lot more complicated than that: remote data could change
  the availability of dates, forcing the datepickers to change and banners could be
  added or removed.
  Hard as we tried, we could not keep the main datepicker consistent with the line item
  ones."


#
  [ main datepicker + line item date pickers, show inconsistency in red ]

  "It felt like playing wak-a-mole: every time we fixed an inconsistency, another popped
  up in a different case."

  "Maybe we sucked as programmers. Maybe we were not doing OOP right....?"


#
  [ facebook page, with chats and messages highlighted ]

  "The devs at facebook faced several challenges to maintain the massive app.
  One of them was that they could not keep the red messages baloon consistent with the
  actual chat windows.
  There was always a case where the number was wrong.
  When they fixed one case, another one popped up."

  "This is EXACTLY the same problem we had at Adslot: losing control of the network of calls
  that keeps consistency **across** different Objects."

  "I am not a fan of Facebook, but I don't think they suck or can't OOP right.
  This is a limit inherent to OOP.
  How can we do better?
  "


#
  [ main datepicker + line item date pickers, each with their state ]
  -> redundant information
  -> more stuff to update
  -> more things  that can go wrong


#
  [ main datepicker crossed in red, lineitem datepicker state only ]
  -> Our variables CANNOT describe an unwanted state


#
  [ renderFunction(startDate, endDate, onChangeCallback) ]
  -> We can do this because React ensures that ALL information is
    reconsidered at EVERY render

  "So how do we turn that state into something that the browser can render?"


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
  -> My model makes it *impossible* for more than one datepicker to be open at the same time.
  -> Opening a datepicker *inherently* closes all others


#
  -> We make unwanted states *impossible*
  -> The best unit test is the one you don't have to write
  -> This *cannot* be done with OOP
  -> First we model the state, *then* we write the code to render it
  -> Code our interfaces --> *Model first* <--
  -> ML types and static type checking allow to crank this technique up to 11


#
  -> Sometimes it's ok to have stateful components
  -> Often the state is so simple that it's not worth to extract it and involve Redux and all its boilerplate

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




# Metro

## A Lightweight Clone of Ruby's famous Rails

Metro combines Conductor, a bare-bones ORM with Shuttle, a bare-bones MVC. These bones may be bare, but they'll get you there!

Both Conductor and Shuttle are based on Rails' ActiveRecord and MVC, respectively. Conductor utilizes and communicates with a SQLite3 database to pull relevant data, while Shuttle creates the server, processes controller actions, renders views, and uses middleware where appropriate.

## Features & Implementation

### Conductor

Conductor is made up of Four main ruby files:
  .db_connection
  .sql_object
  .searchable
  .associatable

db_connection is

### Shuttle

<!-- ### Single-Page Interface

Apart from the initial Auth, all pages on PerfectPair are reactive content delivered on a static page. The root div listens to the flux stores, and renders each component based on listeners and callbacks which dynamically update the react DOM, keeping the content moving and the interface a delight to use. All information is kept on the back end, and brought through in limited scope through API calls. In fact, the only public data is the kind of data that you would want people to see. No table row ids, no emails, all user specific stuff is handled on the back end and queried/interpreted through back end functionality. The routes are even designed around using usernames as params. Because all of this info is public, it doesn't matter how malicious the intent, no user can reach past the scope they've already been given

```ruby
    get '/', to: 'users#get_user'
    post '/', to: 'users#create_user'
    patch '/', to: 'users#update_user'

    get '/user/conversations/:username', to: 'users#get_conversation'
    get '/users/:username', to: 'users#other_user'
    get '/users/:username/photos', to: 'users#other_user_photos'
    get '/users/:username/about', to: 'users#other_user_about'
  ```

### Question Answering and Matching Algorithm

  While the actual calculation for determining answer similarity is kept on the backend for the sake of simplicity and discreteness, the public nature of question answering and explaining your answers, as well as the relative desirability of each answer means each user could technically get a good approximaton of how much of a match they are with someone by looking at their answers. However, nobody has time for any of that nonsense! We do it for you!

  Every time a user answers a question, they point out which answers they'd like to see, and weight the importance of those answers with a basic four-point scale, ranging from `irrelevant` to `dealbreaker`.

  These results are stored (and easily editable on the user's profile page) and compared with each user in the displayed group of matches. Question answering provides an instant update of your match percentage with each user, meaning you can totally game your questions if you wanted to, but buddy, that's not how love works.

  On the database side, the questions are joined on a question choices table, referring to the answers through a series of foreign keys. the importance and answered choices are queried based on all the questions that both you and the other user have answered!

  The question display is almost absurdly complex. On one single `ProfileQuestionsTab`, you can answer questions, skip a question you don't want to answer, re-answer a question, add/edit an explanation, and have it all change instantaneously!



## Future Directions for the Project

Having it work on heroku would be nice -->

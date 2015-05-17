// An example Parse.js Backbone application based on the todo app by
// [Jérôme Gravel-Niquet](http://jgn.me/). This demo uses Parse to persist
// the todo items and provide user authentication and sessions.

$(function() {

  Parse.$ = jQuery;

  // Initialize Parse with your Parse application javascript keys
  Parse.initialize("bbvNJHfvOXZ33SwTCYAq08pqe8MkmgALRI9NZC5f",
                   "ahzUgMB25URDB7V7sUv14mK9wtynAzEsGIkdPv3U");

  // Todo Model
  // ----------

  // Our basic Todo model has `content`, `order`, and `done` attributes.
  var Offer = Parse.Object.extend("Offer", {

  });
  // Todo Collection
  // ---------------

  var OfferList = Parse.Collection.extend({
    model: Offer,
  });

  // Todo Item View
  // --------------

  // The DOM element for a todo item...
  var OfferView = Parse.View.extend({

    //... is a list tag.
    tagName:  "div",
    className: "col s4",

    // Cache the template function for a single item.
    template: _.template($('#item-template').html()),

    // The DOM events specific to an item.
    events: {
      // "click .toggle"              : "toggleDone",
      // "dblclick label.todo-content" : "edit",
      // "click .todo-destroy"   : "clear",
      // "keypress .edit"      : "updateOnEnter",
      // "blur .edit"          : "close"
    },

    // The OfferView listens for changes to its model, re-rendering. Since there's
    // a one-to-one correspondence between a Todo and a OfferView in this
    // app, we set a direct reference on the model for convenience.
    initialize: function() {
      _.bindAll(this, 'render', 'close', 'remove');
      this.model.bind('change', this.render);
      this.model.bind('destroy', this.remove);
    },

    // Re-render the contents of the todo item.
    render: function() {
      $(this.el).html(this.template(this.model.toJSON()));
      this.input = this.$('.edit');
      return this;
    },

    edit: function() {
      $(this.el).addClass("editing");
      this.input.focus();
    },

    // Close the `"editing"` mode, saving changes to the todo.
    close: function() {
      this.model.save({content: this.input.val()});
      $(this.el).removeClass("editing");
    },

    // If you hit `enter`, we're through editing the item.
    updateOnEnter: function(e) {
      if (e.keyCode == 13) this.close();
    },

    // Remove the item, destroy the model.
    clear: function() {
      this.model.destroy();
    }

  });

  // The Application
  // ---------------

  // The main view that lets a user manage their todo items
  var ManageTodosView = Parse.View.extend({


    // Delegated events for creating new items, and clearing completed ones.
    events: {
      // "keypress #new-todo":  "createOnEnter",
      // "click #clear-completed": "clearCompleted",
      // "click #toggle-all": "toggleAllComplete",
      // "click .log-out": "logOut",
      // "click ul#filters a": "selectFilter"
    },

    el: ".content",

    // At initialization we bind to the relevant events on the `Todos`
    // collection, when items are added or changed. Kick things off by
    // loading any preexisting todos that might be saved to Parse.
    initialize: function() {
      var self = this;

      // _.bindAll(this, 'addOne', 'addAll', 'addSome', 'render', 'toggleAllComplete', 'logOut', 'createOnEnter');

      // Main todo management template
      // Create our collection of Todos
      this.offers = new OfferList;

      // Setup the query for the collection to look for todos from the current user
      this.offers.query = new Parse.Query("Offer");
      this.offers.bind('add',     this.addOne);
      this.offers.bind('all',     this.render);

      // Fetch all the todo items for this user
      this.offers.fetch({success: function () {self.addAll()}});
    },
    // Re-rendering the App just means refreshing the statistics -- the rest
    // of the app doesn't change.
    render: function() {
      // this.delegateEvents();
    },

    // Add a single todo item to the list by creating a view for it, and
    // appending its element to the `<ul>`.
    addOne: function(offer, index) {
      var addRow = index % 3 == 0;
      console.log(index);
      console.log(addRow);
      var row;
      // if (addRow) {
      //   $(".content").append('<div class="row"></div>');
      // }
      var view = new OfferView({model: offer});
      $(".row").append(view.render().el);
    },

    // Add all items in the Todos collection at once.
    addAll: function(collection, filter) {
      $(".row").html("");
      this.offers.each(this.addOne);
    }
  });

  
  // The main view for the app
  var AppView = Parse.View.extend({
    // Instead of generating a new element, bind to the existing skeleton of
    // the App already present in the HTML.
    el: $("#app"),

    initialize: function() {
      this.render();
    },

    render: function() {
      new ManageTodosView();
      // if (Parse.User.current()) {
      //   new ManageTodosView();
      // } else {
      //   new LogInView();
      // }
    }
  });

  new AppView;
});

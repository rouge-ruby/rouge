<h3>List</h3>
<% if !@list || @list.empty? %>
<p>not found.</p>
<% else %>
<table>
  <tbody>
    <% @list.each_with_index do |item, i| %>
    <tr bgcolor="<%= i%2 == 0 ? '#FFCCCC' : '#CCCCFF' %>">
      <td><%= item %></td>
    </tr>
    <% end %>
  </tbody>
</table>
<% end %>

<%# Sometimes you just need to use a variable or two %>
<% header_tag = 'h1' %>

<<%= header_tag %>>
  it's a header!
</<%= header_tag %>>

<p>
  Some text
</p>
<script>
  var foo = 1;
  var bar = <%= bar %>;
  var baz = {
    a: 1,
    b: 2
  };
</script>
<style>
.foo {
  line-height: <%= @line_height %>
}
</style>
<p>
  Some another text
</p>
thumbsup 0

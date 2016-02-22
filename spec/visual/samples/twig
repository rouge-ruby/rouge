{% include 'header.html' %}

<ul>
{% for user in users %}
  * {{ user.name|capitalize }}
{% endfor %}
</ul>

{# A comment #}

{% if current_user.admin is not true %}
  {% flush %}
{% endif %}

{% include 'footer.html' %}

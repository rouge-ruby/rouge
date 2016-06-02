{$foo}

<div>test</div>

<script type="text/javascript">
  console.log({
    foo: 'bar',
    'foo2': 'bar2',
  });
  function test() {
    console.log("Making sure we don't treat javascript's { 's as smarty tags");
  }
</script>

<script type="text/javascript">
  // This shows how a smarty tag inside of javascript does sometimes
  // break things. I'm not sure how to fix this.
  console.log({
    foo: 'bar',
    {test}
    'foo2': 'bar2',
  });
</script>

{* test comment *}
{foo} {$baz}

{foo} {bar} {baz}

{foo bar='single quotes' baz="double quotes" test3=$test3}

<ul>
  {foreach from=$myvariable item=data}
    <li>{$data.field}</li>
  {foreachelse}
    <li>No Data</li>
  {/foreach}
</ul>

<div class="{if $foo}class1{else}class2{/if}">{$foo.bar.baz}</div>

{* test 
   multi-line
   comment
*}

{$bar[42]}
{$bar.$foo}


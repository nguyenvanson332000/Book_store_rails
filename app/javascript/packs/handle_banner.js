$( document ).on( "turbolinks:load", function ()
{
  $( '.banner-account' ).click( function ()
  {
    $.ajax( {
      type: 'PATCH',
      url: "/admin/users/" + $( this ).data().id,
      beforeSend: function ( xhr ) { xhr.setRequestHeader( 'X-CSRF-Token', $( 'meta[name="csrf-token"]' ).attr( 'content' ) ) },
      data: {
        id: $( this ).data().id,
        type: $( this ).data().type
      },
      dataType: 'JSON'
    } ).done( function ( data )
    {
      alert( data.flash.success );
      window.location.reload();
    } ).fail( function ( data )
    {
      alert( "Xử lý thất bại" );
    } );
  } );
} )

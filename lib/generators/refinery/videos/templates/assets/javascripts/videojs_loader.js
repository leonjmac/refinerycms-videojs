window.onload = function ()
{
    if ($('video').is('*')) {
        $('body').append('<link href="//vjs.zencdn.net/c/video-js.css" rel="stylesheet">');
        $('body').append('<script src="//vjs.zencdn.net/c/video.js"></script>');
    }
};
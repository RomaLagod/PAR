
function slideShow()
{
   this.slideshow = {
         timer: 0,
         current_index: 0,
         transitioning: false };
   
   this.getSlideshow = function() {return this.slideshow;};
   this.buildSlideshow = makeSlideshow;
   this.swapSlides = swap;
   this.stopSlideshow = function ()
   {
      if (this.slideshow.timer != 0)
         clearTimeout(this.slideshow.timer);
   }
   this.nextIndex = function(offset)
   {
      next_index = ((offset === undefined)
            ? this.slideshow.current_index + 1
            : (offset >= 0)
              ? offset
              : offset + this.slideshow.slides.length) % this.slideshow.slides.length;
      return next_index;
   }
}

function swap(index)
{
   this.stopSlideshow();
   var current_index = this.slideshow.current_index,
   current_slide = this.slideshow.slides[current_index],
   next_index = this.nextIndex(index),
   next_slide = this.slideshow.slides[next_index];
   this.slideshow.current_index = next_index;

  styleElement(current_slide, { opacity: 0, zIndex: 898 });
  styleElement(next_slide, { opacity: 1, zIndex: 990 });
}


// Returns a fresh object that is the result of combining all of the supplied objects.
function extendObject() {
   var objects = arguments.length,
   result = {};
   for (var i = 0; i < objects; i++) {
      var object = arguments[i];
      for (key in object)
         result[key] = object[key];
   }

    return result;
}

  // Kludgy styling function to avoid repetition.
  // <code>element</code> is a DOM element (like what you'd get from document.getElementById), and
  // <code>styles</code> is an object with camel-cased CSS attributes as keys and values as, well, values.
  function styleElement(element, styles) {
    for (key in styles) {
      element.style[key] = styles[key];

      // Shim for the IE family.
      if (key == "opacity")
        element.style.filter = "alpha(opacity=" + (styles[key] * 100) + ")";
    }
  }

  // Returns all of the HTML elements that are the children of <code>element</code>.
  // (Ignores text nodes, comment nodes, and so on.)
  function children(element) {
    var result = [],
        nodes = element.childNodes,
        count = nodes.length;

    for (var i = 0; i < count; i++)
      if (nodes[i].nodeType == 1)
        result.push(nodes[i]);

    return result;
  }

  // Makes a fading slideshow.
  // <code>parent</code> is the ID of the element containing the slides,
  // <code>previous</code> is the ID of the element that will show the previous slide on click,
  // <code>next</code> is the ID of the element that will show the next slide on click, and
  // <code>options</code> is an optional argument containing values to override the default times.
  
  // Clicking either next or previous will disable automatic transitioning.
  
  // Possible keys for <code>options</code> are:
  //   transition (the number of milliseconds each transition should take)
  //   wait (the number of milliseconds to wait before transitioning to the next slide)
function makeSlideshow(parent, previous, next, options) 
{
    parent = document.getElementById(parent);
    options = extendObject({
      levelIncrement: 0.01,
      transition: 1000,
      wait: 5000
    }, (options) ? options : {});

    var slides = children(parent);
    this.slideshow = { slides: slides,
          timer: 0,
          current_index: 0,
          transitioning: false };

    
    var count = slides.length,
        delay = options.transition / 100;
        levelInc = options.levelIncrement;
    
    function show(slideshow, index) {
      if (slideshow.transitioning)
        return;

      var current_index = slideshow.current_index,
          current_slide = slideshow.slides[current_index],
          next_index = ((index === undefined)
                        ? current_index + 1
                        : (index >= 0)
                          ? index
                          : index + count) % count,
          next_slide = slideshow.slides[next_index];

      styleElement(current_slide, { opacity: 0, zIndex: 899 });
      styleElement(next_slide, { opacity: 0, zIndex: 990 });

      var oLevel;
      function loop() 
      {
        oLevel = +(next_slide.style.opacity) + levelInc;
        styleElement(next_slide, { opacity: oLevel });
        if (oLevel < 1) 
        {
          window.setTimeout(loop, delay);
        } 
        else 
        {
          styleElement(current_slide, { zIndex: 898 });
          slideshow.current_index = next_index;
          slideshow.transitioning = false;

          if (index >= 0) 
          {
            if (slideshow.timer) 
            {
              window.clearTimeout(slideshow.timer);
              slideshow.timer = 0;
            }
          } 
          else 
          {
             slideshow.timer = window.setTimeout(function() { show(slideshow); }, options.wait);
          }
        }
      }

      slideshow.transitioning = true;
      loop();
    }
    
    var max_height = 0;
        max_width = 0;
    for (var i = 0; i < slides.length; i++) {
      var slide = slides[i];
      if (slide.offsetHeight > max_height) max_height = slide.offsetHeight;
      if (slide.offsetWidth > max_width) max_width = slide.offsetWidth;
    }

    styleElement(parent, {
      height: max_height + "px",
      position: "relative",
      width: max_width + "px"
    });
    
    for (var i = 0; i < slides.length; i++)
      styleElement(slides[i], { display: "inline", position: "absolute", zIndex: 898, opacity: 0 });
    styleElement(slides[0], { zIndex: 899, opacity: 1 });

    var ss = this.slideshow;
    var me = this;
    
    if (previous)
      document.getElementById(previous).onclick = function() {
        me.swapSlides(ss.current_index - 1);
        return false;
      }

    if (next)
      document.getElementById(next).onclick = function() {
        me.swapSlides(ss.current_index + 1);
        return false;
      }

    if (options.wait != 0)
       this.slideshow.timer = window.setTimeout(function() { show(ss); }, (options.wait / 2));
  }


### BUMP visuals

a series of visual that will potentially be displayed on a big screen during the [Bump festival in Kortrijk on the 24th of june 2016](http://bump-festival.be/)


the basic setup is a Processing 3 sketch with the following code:
    PShader shader;
    String name = "shader_name";

    PImage logo;

    void setup() {
      size( 1200, 500, P3D );
      noStroke();
      shader = loadShader( name + ".glsl");
      logo = loadImage("../logo.png");
    }

    void draw() {

      shader.set("u_resolution", float(width), float(height));
      shader.set("u_time", 1000 + millis() / 1000.0);

      shader(shader);
      rect(0,0,width,height);

      float n = norm( float( height ) / 2., 0., float( height ) );
      int w = int( logo.width  * n );
      int h = int( logo.height * n );

      image( logo, width/2-w/2,height/2-h/2,w,h );

    }
    void keyPressed(){
      shader = loadShader( name + ".glsl");
      saveFrame( name + ".png" );
    }

<div>pressing any key will reload the shader an take a snapshot.</div>
<div>you can copy paste any of the following snippets (click editor to open the code)</div>
<div>this is mostly hacked from the following shaders:<br/>

[https://www.shadertoy.com/view/MlXGDf](https://www.shadertoy.com/view/MlXGDf)

[https://www.shadertoy.com/view/Xds3zN](https://www.shadertoy.com/view/Xds3zN)

[http://thebookofshaders.com/](http://thebookofshaders.com/)

link1

[<img src="blocks_color_bright/blocks_bright.png">](http://player.thebookofshaders.com/?log=160620065714)

link2

[![color blocks bright](blocks_color_bright/blocks_bright.png)](http://player.thebookofshaders.com/?log=160620065714)


    <li>
        color blocks bright<br>
        <a href="">
            <br>
        </a>
        <a href="http://thebookofshaders.com/edit.php?log=160620065457">editor</a>
        <br>
    </li>

    <li>
        color blocks dark<br>
        <a href="http://player.thebookofshaders.com/?log=160620070406">
        <img src="blocks_color_dark/blocks_dark.png"><br>
        </a>
        <a href="http://thebookofshaders.com/edit.php?log=160620070339">editor</a>
        <br>
    </li>

    <li>
        cone<br>
        <a href="http://player.thebookofshaders.com/?log=160620090418">
            <img src="noisy_cone/noisy_cone.png"><br>
        </a>
        <a href="http://thebookofshaders.com/edit.php?log=160620090347">editor</a>
        <br>
    </li>

    <li>
        black box<br>
        <a href="http://player.thebookofshaders.com/?log=160620080832">
            <img src="blackbox/black_box.png"><br>
        </a>
        <a href="http://thebookofshaders.com/edit.php?log=160620080758">editor</a>
        <br>
    </li>

    <li>
        animated Chladni pattern<br>
        <a href="http://player.thebookofshaders.com/?log=160620071347">
        <img src="chladni/chladni.png"><br>
        </a>
        <a href="http://thebookofshaders.com/edit.php?log=160620071328">editor</a>
        <br>
    </li>

    <li>
        gooey<br>
        <a href="http://player.thebookofshaders.com/?log=160620074649">
        <img src="gooey/gooey.png"><br>
        </a>
        <a href="http://thebookofshaders.com/edit.php?log=160620074633">editor</a>
        <br>
    </li>

    <li>
        Klimt<br>
        <a href="http://player.thebookofshaders.com/?log=160620082246">
            <img src="klimt/klimt.png"><br>
        </a>
        <a href="http://thebookofshaders.com/edit.php?log=160620082232">editor</a>
        <br>
    </li>

    <li>
        monolith<br>
        <a href="http://player.thebookofshaders.com/?log=160620092119">
            <img src="monolith/monolith.png"><br>
        </a>
        <a href="http://thebookofshaders.com/edit.php?log=160620092104">editor</a>
        <br>
    </li>

    <li>
        panopticon<br>
        <a href="http://player.thebookofshaders.com/?log=160620072548">
        <img src="panopitcon/panopitcon.png"><br>
        </a>
        <a href="http://thebookofshaders.com/edit.php?log=160620072511">editor</a>
        <br>
    </li>

    <li>
        polygons<br>
        <a href="http://player.thebookofshaders.com/?log=160620095646">
            <img src="polygons/polygons.png"><br>
        </a>
        <a href="http://thebookofshaders.com/edit.php?log=160620095628">editor</a>
        <br>
    </li>


    <li>
        vorogrid<br>
        <a href="http://player.thebookofshaders.com/?log=160620100408">
            <img src="vorogrid/vorogrid.png"><br>
        </a>
        <a href="http://thebookofshaders.com/edit.php?log=160620100323">editor</a>
        <br>
    </li>
    <li>
        waves<br>
        <a href="http://player.thebookofshaders.com/?log=160620093524">
            <img src="waves/waves.png"><br>
        </a>
        <a href="http://thebookofshaders.com/edit.php?log=160620093508">editor</a>
        <br>
    </li>


</div>


</body>
</html>
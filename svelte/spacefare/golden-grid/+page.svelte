<script>
//spacefare/golden-grid
</script>

<template lang="pug">
#mainline.bg-silver.u-shadow
  header.c-card__header
    h2.c-heading.c-heading--small
      | golden-grid
      .c-heading__sub ---
  .c-card__body
    .m1.bg-darken-1
      #bloviation.contents
        canvas#seen-canvas(width='800', height='800')
        #reference
      script(type='text/javascript').
        (function() {
          var slice = [].slice,
            extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
            hasProp = {}.hasOwnProperty,
            indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };
          (function() {
                  return $(function() {
                    var B, Edge, Edges, Origin, Point, Points, Ratios, Triangle, Triangles, _, allEdges, allPoints, allTriangles, badScene, basis, bigM, bladeScheme, blades, color, colorScheme, context, createEmplace, dot, dumpText, fillColor, g, height, i, j, k, latticeOrigin, len, newDot, powers, ref, rho, rhoShow, scene, seenModels, siggy, slope, v;
                    try {
                      height = 800;
                      T = require("halvalla");
                      B = require("backbone");
                      _ = require("underscore");
                      rho = 50 / 1.618033;
                      powers = (function() {
                        var j, results;
                        results = [];
                        for (i = j = 0; j <= 10; i = ++j) {
                          results.push(rho = rho * 1.61803398);
                        }
                        return results;
                      })();
                      dumpText = function() {
                        var j, len, r, t, text;
                        text = 1 <= arguments.length ? slice.call(arguments, 0) : [];
                        r = "--";
                        for (j = 0, len = text.length; j < len; j++) {
                          t = text[j];
                          if (_.isString(t)) {
                            r += t;
                          } else {
                            r += JSON.stringify(t);
                          }
                          r += " --";
                        }
                        return $("#reference").append(T.render(T.p(r)));
                      };
                      rhoShow = T.render(T.div((function(_this) {
                        return function() {
                          var j;
                          for (i = j = 0; j <= 10; i = ++j) {
                            T.p("rho^" + i + "=" + powers[i] + ". ");
                          }
                          return null;
                        };
                      })(this)));
                      Ratios = [2, 1, 0, -1];
                      colorScheme = ['#e6194B', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#42d4f4', '#f032e6', '#bfef45', '#fabed4', '#469990', '#dcbeff', '#9A6324', '#fffac8', '#800000', '#aaffc3', '#808000', '#ffd8b1', '#000075', '#a9a9a9', '#ffffff', '#000000'];
                      blades = {};
                      ref = ["groucho", "harpo", "chico", "stan", "babe"];
                      for (i = j = 0, len = ref.length; j < len; i = ++j) {
                        basis = ref[i];
                        color = seen.Colors.hex(colorScheme[i]);
                        color.a = 140;
                        slope = i * 2 * Math.PI / 5;
                        blades[basis] = {
                          angle: i * 72,
                          slope: slope,
                          points: (function() {
                            var len1, m, results;
                            results = [];
                            for (k = m = 0, len1 = powers.length; m < len1; k = ++m) {
                              v = powers[k];
                              results.push(new seen.P().transform(new seen.Matrix().translate(v).rotz(slope)));
                            }
                            return results;
                          })(),
                          color: color
                        };
                      }
                      Triangle = (function(superClass1) {
                        extend(Triangle, superClass1);
        
                        function Triangle() {}
        
                        return Triangle;
        
                      })(Backbone.Model);
                      Triangles = (function(superClass1) {
                        extend(Triangles, superClass1);
        
                        Triangles.prototype.model = Triangle;
        
                        function Triangles() {}
        
                        return Triangles;
        
                      })(Backbone.Collection);
                      allTriangles = new Triangles();
                      Edge = (function(superClass1) {
                        extend(Edge, superClass1);
        
                        function Edge() {}
        
                        return Edge;
        
                      })(Backbone.Model);
                      Edges = (function(superClass1) {
                        extend(Edges, superClass1);
        
                        function Edges() {
                          return Edges.__super__.constructor.apply(this, arguments);
                        }
        
                        Edges.prototype.model = Edge;
        
                        Edges.prototype.pipeIt = function(s, d, color) {
                          var dp, interpolatePoints, ln1, sp;
                          interpolatePoints = function(a, b, t) {
                            return seen.P(a.x * (1.0 - t) + b.x * t, a.y * (1.0 - t) + b.y * t, a.z * (1.0 - t) + b.z * t);
                          };
                          sp = s.get("pointFinal");
                          dp = d.get("pointFinal");
                          this.add(sp, dp);
                          ln1 = seen.Shapes.pipe(interpolatePoints(sp, dp, .9), interpolatePoints(sp, dp, .2));
                          ln1.fill(color);
                          return bladeModel.add(ln1);
                        };
        
                        return Edges;
        
                      })(Backbone.Collection);
                      allEdges = new Edges();
                      Point = (function() {
                        function Point() {}
        
                        return Point;
        
                      })();
                      Points = (function(superClass1) {
                        extend(Points, superClass1);
        
                        function Points() {
                          return Points.__super__.constructor.apply(this, arguments);
                        }
        
                        Points.prototype.model = Point;
        
                        Points.prototype.addToLattice = function(who, where, what, parent) {
                          var badboy, pointFinal, sig;
                          try {
                            pointFinal = seen.P(0, 0, 0).transform(what.m).round();
                            if (!(1000 >= pointFinal.magnitude())) {
                              return null;
                            }
                            sig = siggy(parent, who, where);
                            dumpText("New Point", sig, who, parent);
                            return this.add({
                              id: what.surfaces[0].id,
                              blade: who,
                              offset: where,
                              pointFinal: pointFinal,
                              signature: sig
                            });
                          } catch (error) {
                            badboy = error;
                            return alert("233 " + badboy);
                          }
                        };
        
                        return Points;
        
                      })(Backbone.collection);
                      allPoints = new Points();
                      fillColor = seen.Colors.rgb(255, 5, 5);
                      newDot = function(theColor, text) {
                        var shape;
                        if (theColor == null) {
                          theColor = fillColor;
                        }
                        if (text == null) {
                          text = "origin";
                        }
                        shape = new seen.Shape('tri', [new seen.Surface([seen.P(-1, -1, 0), seen.P(1, -1, 0), seen.P(0, 4, 0)])]);
                        return shape.fill(new seen.Material(theColor)).scale(5);
                      };
                      latticeOrigin = new latticePoint({
                        id: "o0",
                        blade: "origin",
                        offset: 0,
                        pointFinal: seen.P(0, 0, 0),
                        signature: "_"
                      });
                      allPoints.add(latticeOrigin);
                      dot = null;
                      seenModels = new seen.Models["default"]();
                      bladeScheme = ["groucho", "harpo", "chico", "stan", "babe", "groucho", "chico", "babe", "harpo", "stan", "groucho"];
                      siggy = function(p, blade, wp) {
                        return (p.get("signature")) + "/" + blade + "-" + blades[blade].angle + "." + wp;
                      };
                      Origin = new seen.Shape('tri', [new seen.Surface([seen.P(-1, -1, 0), seen.P(1, -1, 0), seen.P(0, 4, 0)])]);
                      Origin.fill(new seen.Material('#880000')).scale(5);
                      seenModels.add(Origin);
                      createEmplace = function(parent, inputPower) {
                        var blade, blade1, blade2, destination, m, n, o, parent2, ref1, ref2, results, results1;
                        if (inputPower >= 0) {
                          results = [];
                          for (i = m = 0; m <= 4; i = ++m) {
                            blade = bladeScheme[i];
                            destination = buildPoint(blade, inputPower, parent);
                            if (!destination) {
                              continue;
                            }
                            results.push(allEdges.pipeIt(parent, destination, colorScheme[inputPower + 5]));
                          }
                          return results;
                        } else {
                          for (i = n = 0; n <= 4; i = ++n) {
                            ref1 = bladeScheme.slice(i, +(i + 1) + 1 || 9e9), blade2 = ref1[0], blade1 = ref1[1];
                            parent2 = buildPoint(blade1, 0, parent);
                            if (!parent2) {
                              continue;
                            }
                            pipeIt(parent, parent2, '#123456');
                            destination = buildPoint(blade2, 0, parent2);
                            if (!destination) {
                              continue;
                            }
                            pipeIt(parent2, destination, '#345612');
                          }
                          results1 = [];
                          for (i = o = 5; o <= 9; i = ++o) {
                            ref2 = bladeScheme.slice(i, +(i + 1) + 1 || 9e9), blade1 = ref2[0], blade2 = ref2[1];
                            parent2 = buildPoint(blade1, 2, parent);
                            pipeIt(parent, parent2, '#456123');
                            if (!parent2) {
                              continue;
                            }
                            destination = buildPoint(blade2, 1, parent2);
                            results1.push(pipeIt(parent2, destination, '#5eee23'));
                          }
                          return results1;
                        }
                      };
                      dumpText("JAH here");
                      dumpText(latticePoints.length);
                      g = allPaths.mostPaths();
                      dumpText("popular destination", g);
                      dumpText("JAH where");
                      dumpText("JAH nowhere");
                      scene = new seen.Scene({
                        model: bigM = seenModels,
                        viewport: seen.Viewports.center(height, height),
                        camera: new seen.Camera({
                          projection: seen.Projections.perspective()
                        })
                      });
                      context = seen.Context('seen-canvas', scene);
                      return context.render();
                    } catch (error) {
                      badScene = error;
                      return alert("Seenery fail " + badScene);
                    }
                  });
                })();
        })();
  footer.c-card__footer
    p.c-text--quiet that's all--
</template>

<style>
</style>
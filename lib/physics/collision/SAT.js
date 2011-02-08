define(['../../core', '../../math/vector', '../../geometry/circle', '../../geometry/polygon'], function(Core, Vector, Circle, Polygon) {
  var SeperatingAxisTheorem;
  SeperatingAxisTheorem = (function() {
    function SeperatingAxisTheorem() {}
    SeperatingAxisTheorem.test = function(a, b) {
      var aIsPoly, bIsPoly;
      aIsPoly = a instanceof Polygon;
      bIsPoly = b instanceof Polygon;
      if (!aIsPoly && !bIsPoly) {
        return this.checkCircles(a, b);
      }
      if (aIsPoly && bIsPoly) {
        return this.checkPolygons(a, b);
      }
      if (!aIsPoly) {
        return this.checkCircleVersusPolygon(a, b);
      }
      if (!bIsPoly) {
        return this.checkCircleVersusPolygon(b, a);
      }
    };
    SeperatingAxisTheorem.checkCircles = function(a, b) {
      var aSubtractB, collision, difference, distSquared, distance, totalRadius;
      aSubtractB = a.position.subtract(b);
      totalRadius = a.radiusT + b.radiusT;
      distSquared = aSubtractB.lengthSquared();
      if (distSquared > (totalRadius * totalRadius)) {
        return false;
      }
      distance = Math.sqrt(distSquared);
      difference = totalRadius - distance;
      collision = {
        shapeA: a,
        shapeB: b,
        distance: distance,
        separation: Vector.multiply(distance, difference),
        shapeAContained: a.radiusT <= b.radiusT && dist <= b.radiusT - a.radiusT,
        shapeBContained: b.radiusT <= a.radiusT && dist <= a.radiusT - b.radiusT,
        vector: aSubB.normalize()
      };
      collision.overlap = collision.separation.length();
      return collision;
    };
    SeperatingAxisTheorem.checkPolygons = function(a, b) {
      var axesA, axesB, axis, collision, distance, i, j, max1, max2, min1, min2, offset, shortestDistance, test1, test2, testNum, vertsA, vertsALen, vertsB, vertsBLen;
      i = 0;
      j = 1;
      min1 = 0;
      max1 = 0;
      min2 = 0;
      max2 = 0;
      axis = null;
      test1 = 0;
      test2 = 0;
      offset = 0;
      testNum = 0;
      vertsA = a.verticesT.concat();
      vertsB = b.verticesT.concat();
      vertsALen = vertsA.length;
      vertsBLen = vertsB.length;
      axesA = a.axes.concat();
      axesB = a.axes.concat();
      collision = {};
      shortestDistance = Number.MAX_VALUE;
      /*
      			if vertsALen is 2
      				temp = Vector.subtract vertsA[1], vertsA[0]
      				temp.i = -temp.i
      				temp.truncate 0.0000000001
      				vertsA.push vertsA[1].clone().add temp
      			if vertsBLen is 2
      				temp = Vector.subtract vertsB[1], vertsB[0]
      				temp.i = -temp.i
      				temp.truncate 0.0000000001
      				vertsB.push vertsB[1].clone().add temp
      			*/
      while (i < vertsALen) {
        /*
        				axis = axesA[i]

        				projA = a.project axis
        				projB = b.project axis

        				return false if projA[0] - projB[1] > 0 or projB[0] - projA[1]

        				distance = -(projB[1] - projA[0])

        				if Math.abs distance < shortestDistance
        				*/
        axis = this.findNormalAxis(vertsA, i);
        min1 = max1 = axis.dot(vertsA[0]);
        j = 1;
        while (j < vertsALen) {
          testNum = axis.dot(vertsA[j]);
          if (testNum < min1) {
            min1 = testNum;
          }
          if (testNum > max1) {
            max1 = testNum;
          }
          j++;
        }
        min2 = max2 = axis.dot(vertsB[0]);
        j = 1;
        while (j < vertsBLen) {
          testNum = axis.dot(vertsB[j]);
          if (testNum < min2) {
            min2 = testNum;
          }
          if (testNum > max2) {
            max2 = testNum;
          }
          j++;
        }
        test1 = min1 - max2;
        test2 = min2 - max1;
        if (test1 > 0 || test2 > 0) {
          return false;
        }
        distance = -(max2 - min1);
        if (Math.abs(distance) < shortestDistance) {
          collision.overlap = distance;
          collision.unitVector = axis;
          shortestDistance = Math.abs(distance);
        }
        i++;
      }
      collision.shapeA = a;
      collision.shapeB = b;
      collision.separation = Vector.multiply(collision.unitVector, collision.overlap);
      return collision;
    };
    SeperatingAxisTheorem.checkCircleVersusPolygon = function(circ, poly) {
      var a, b, closestVector, collision, distance, i, j, max1, max2, min1, min2, normalAxis, offset, p2, temp, test1, test2, testDistance, testNum, vectorOffset, vectors, verts, vertsLen;
      a = circ.position;
      b = poly.position;
      test1 = test2 = testNum = min1 = max1 = min2 = max2 = 0;
      normalAxis = null;
      offset = 0;
      vectorOffset = 0;
      vectors = [];
      collision = {};
      p2 = [];
      distance = 0;
      testDistance = Number.MAX_VALUE;
      closestVector = new Vector;
      verts = poly.vertices.concat();
      vertsLen = verts.length;
      vectorOffset = Vector.subtract(b, a);
      if (vertsLen === 2) {
        temp = Vector.subtract(verts[1], verts[0]);
        temp.i = -temp.i;
        verts.push(verts[1].clone().add(temp.truncate(0.00001)));
      }
      i = 0;
      while (i < vertsLen) {
        distance = (a.i - (b.i + verts[i].i)) * (a.i - (b.i + verts[i].i)) + (a.j - (b.j + verts[i].j)) * (a.j - (b.j + verts[i].j));
        if (distance < testDistance) {
          testDistance = distance;
          closestVector = Vector.add(b, verts[i]);
        }
        i++;
      }
      normalAxis = Vector.subtract(closestVector, a).normalize();
      console.log(normalAxis.isZero());
      min1 = max1 = normalAxis.dot(verts[0]);
      j = 1;
      while (j < vertsLen) {
        testNum = normalAxis.dot(verts[j]);
        if (testNum < min1) {
          min1 = testNum;
        }
        if (testNum > max1) {
          max1 = testNum;
        }
        j++;
      }
      max2 = circ.radiusT;
      min2 -= circ.radiusT;
      offset = normalAxis.dot(vectorOffset);
      min1 += offset;
      max1 += offset;
      test1 = min1 - max2;
      test2 = min2 - max1;
      if (test1 > 0 || test2 > 0) {
        return false;
      }
      i = 0;
      while (i < vertsLen) {
        normalAxis = this.findNormalAxis(verts, i);
        min1 = max1 = normalAxis.dot(verts[0]);
        j = 1;
        while (j < vertsLen) {
          testNum = normalAxis.dot(verts[j]);
          if (testNum < min1) {
            min1 = testNum;
          }
          if (testNum > max1) {
            max1 = testNum;
          }
          j++;
        }
        max2 = circ.radiusT;
        min2 = -circ.radiusT;
        offset = normalAxis.dot(vectorOffset);
        min1 += offset;
        max1 += offset;
        test1 = min1 - max2;
        test2 = min2 - max1;
        if (test1 > 0 || test2 > 0) {
          return false;
        }
        i++;
      }
      collision.overlap = -(max2 - min1);
      collision.unitVector = normalAxis;
      collision.shapeA = poly;
      collision.shapeB = circ;
      collision.separation = new Vector(normalAxis.i * (max2 - min1) * -1, normalAxis.j * (max2 - min1) * -1);
      return collision;
    };
    SeperatingAxisTheorem.findNormalAxis = function(vertices, index) {
      var a, b;
      a = vertices[index];
      b = index >= vertices.length - 1 ? vertices[0] : vertices[index + 1];
      return new Vector(-(b.j - a.j), b.i - a.i).normalize();
    };
    return SeperatingAxisTheorem;
  })();
  return SeperatingAxisTheorem;
});
class baseRepresentation
  constructor: (@baseID,@baseQuantity)->
    @fivePlaces = @baseQuantity * @baseQuantity * @baseQuantity * @baseQuantity * @baseQuantity 
    @fivePlaces = @fivePlaces * @fivePlaces if @baseQuantity < 2
    @max = Math.ceil(   @fivePlaces * ( Math.ceil @baseQuantity ))
    resolution =40
    resolution += 15 if @baseQuantity < 2
    @powers = for i in [ 0 .. resolution ] 
      @fivePlaces = @fivePlaces / @baseQuantity
    #console.log @powers[4]
    
  shootFor:(target) ->
    current=0
    result=""
    terminated = false
    tooFar = Math.ceil @baseQuantity
    digitAtPower=(destination,currentEstimate,powerValue)=>
      for i in [1 .. tooFar ]
        return i-1  if destination < (powerValue * i) + currentEstimate
      return tooFar
    lastPower = 1000000 #anything 
    for power,i in @powers
      continue if terminated
      multiplier = digitAtPower target, current, power
      ohNo = multiplier == tooFar
      if ohNo
        terminated = power < 1
        result += "!"
      current += power * multiplier
      result += multiplier
      result += "." if lastpower >= 1 && power < 1
      lastpower = power
    return result + ", diff = #{target-current}"

showBase =(symbol,base,limit=base**5)->
  console.log ""
  console.log ""
  console.log "Inverses and integers in base",symbol
  theBase = new baseRepresentation symbol,base
  #  console.log theBase.max, base, base ** 6
  #  console.log "But limit is:",limit
  for j in [1 .. 40 ]
    spacer = ''
    spacer = " " if j < 10
    console.log "(1/#{j})base",symbol,spacer, (theBase.shootFor 1.0/j) 
  console.log ""
  console.log "integers"
  if limit <75
    for j in [1 .. limit]
      spacer = ''
      spacer = " " if j < 10
      console.log "(#{j})base  ",symbol,spacer, (theBase.shootFor j) 
  else
    for j in [1 .. 75]
      spacer = ''
      spacer = " " if j < 10
      console.log "(#{j})base  ",symbol,spacer, (theBase.shootFor j) 
    console.log "..."
    for j in [limit .. limit+40]
      spacer = ''
      console.log "(#{j})base  ",symbol,spacer, (theBase.shootFor j) 

Phi = ((Math.sqrt 5)+1)/2
showBase "Phi",Phi,115

E = Math.E
showBase "E",E,125
EE = E*E
showBase "E^2",E*E,23830

PI = Math.PI
showBase "PI",PI,360
sqrt2 = Math.sqrt 2
#
showBase "SQRT2",sqrt2,48
#
sqrt3 = Math.sqrt 3
showBase "SQRT3",sqrt3,40
#
sqrt5 = Math.sqrt 5
sqrt6 = Math.sqrt 6
showBase "SQRT5",sqrt5,50
showBase "SQRT6",sqrt6,50
bases= {PI,sqrt5,Phi,sqrt3,sqrt2,sqrt6,E,EE}
for baseID,baseValue of bases
  b = new baseRepresentation baseID,baseValue
  for targetID,targetValue of bases
    console.log "Base #{baseID} encoding for #{targetID}                       ".slice(0,30), b.shootFor targetValue



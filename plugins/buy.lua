do
function run(msg, matches)
  return [[
  👥 قیمت گروه های آنتی اسپم :
  
  💵 ماهیانه سوپرگروه 5000 تومان
  💴 دو ماهه سوپرگروه 9000 تومان
  💶 سه ماهه سوپرگروه 14000 تومان
  
  --------------------------------------
  
برای سفارش و شارژ گروه
به آی دی @AmirDark پیام بدهید.
  ]]
  end
return {
  description = "!buy", 
  usage = " !buy",
  patterns = {
    "^[#/!][Bb]uy$",
  },
  run = run
}
end

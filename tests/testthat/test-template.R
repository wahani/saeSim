# test_that("templateTest", {
#   # Values you always should consider for testing
#   
#   # Valid input:
#   expect_that(tamplateTest("Hallo"), equals("Hallo"))
#   
#   # Which class for the return value do you expect?
#   expect_that(tamplateTest("Hallo"), is_a("character"))
#   
#   # Missing values
#   expect_that(tamplateTest(NA), equals(NA))
#   expect_that(tamplateTest(NULL), equals(NULL))
#   
#   # Missing input (Default behaviour)
#   expect_that(tamplateTest(), equals("hi"))
#   
#   # Expect scalar as input or vector?
#   expect_that(tamplateTest(c("Hi", "hi")), equals(c("Hi", "hi")))
#   
#   # Which input should result in an error?
#   
#   # Which input should result in a warning?
#   
# })

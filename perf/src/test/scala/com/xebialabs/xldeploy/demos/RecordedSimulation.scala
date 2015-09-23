package com.xebialabs.xldeploy.demos

import io.gatling.core.Predef._
import io.gatling.http.Predef._

class RecordedSimulation extends Simulation {

  val httpProtocol = http
    .baseURL("http://deployit.vm:8080")
    .inferHtmlResources()

  val headers_0 = Map(
    "Accept" -> "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
    "Upgrade-Insecure-Requests" -> "1")

  val headers_1 = Map("Accept" -> "image/webp,image/*,*/*;q=0.8")

  val headers_7 = Map(
    "Accept" -> "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
    "Accept-Encoding" -> "gzip, deflate",
    "Origin" -> "http://deployit.vm:8080",
    "Upgrade-Insecure-Requests" -> "1")

  val uri1 = "http://deployit.vm:8080"

  val scn = scenario("RecordedSimulation")
    .exec(http("request_0")
    .get("/petclinic/index.jsp")
    .headers(headers_0)
    .resources(http("request_1")
    .get(uri1 + "/petclinic/images/bullet-arrow.png")
    .headers(headers_1)
    .check(status.is(304)),
      http("request_2")
        .get(uri1 + "/petclinic/images/banner-graphic.png")
        .headers(headers_1)
        .check(status.is(304)),
      http("request_3")
        .get(uri1 + "/favicon.ico")
        .check(status.is(400))))
    .pause(1)
    .exec(http("request_4")
    .get("/petclinic/findOwners.jsp")
    .headers(headers_0)
    .resources(http("request_5")
    .get(uri1 + "/petclinic/images/submit-bg.png")
    .headers(headers_1)
    .check(status.is(304)),
      http("request_6")
        .get(uri1 + "/favicon.ico")
        .check(status.is(400))))
    .pause(3)
    .exec(http("request_7")
    .post("/petclinic/findOwners.jsp")
    .headers(headers_7)
    .formParam("lastName", "benoit")
    .resources(http("request_8")
    .get(uri1 + "/favicon.ico")
    .check(status.is(400))))
    .pause(4)
    .exec(
      http("request_9")
      .get("/petclinic/index.jsp")
    .headers(headers_0)
    .resources(http("request_10")
    .get(uri1 + "/favicon.ico")
    .check(status.is(400))))
    .pause(1)
    .exec(http("request_11")
    .get("/petclinic/vets.jsp")
    .headers(headers_0)
    .resources(http("request_12")
    .get(uri1 + "/favicon.ico")
    .check(status.is(400))))
    .pause(3)
    .exec(http("request_13")
      .get("/favicon.ico")
      .check(status.is(400)))
    .pause(3)
    .exec(
      http("request_14")
        .get("/petclinic/findSuperPets.jsp")
        .headers(headers_0))

  setUp(scn.inject(atOnceUsers(1))).protocols(httpProtocol)
}
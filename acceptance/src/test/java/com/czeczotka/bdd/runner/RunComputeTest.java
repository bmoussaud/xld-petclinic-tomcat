package com.czeczotka.bdd.runner;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

@RunWith(Cucumber.class)
@CucumberOptions(
        format = { "json:target/acc/compute.json" },
        glue = "com.czeczotka.bdd.steps",
        features = "classpath:cucumber/compute.feature"
)
public class RunComputeTest {
}

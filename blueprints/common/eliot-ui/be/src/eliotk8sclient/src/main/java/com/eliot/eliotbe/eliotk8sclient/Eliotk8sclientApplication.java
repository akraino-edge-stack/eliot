package com.eliot.eliotbe.eliotk8sclient;


import io.kubernetes.client.Configuration;
import io.kubernetes.client.util.ClientBuilder;
import io.kubernetes.client.util.KubeConfig;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import io.kubernetes.client.ApiClient;
import org.springframework.context.annotation.Bean;
import java.io.FileReader;
import java.io.IOException;


@SpringBootApplication
public class Eliotk8sclientApplication {

	@Bean
	public static void apiclient() throws IOException {
		// file path to your KubeConfig
        String homePath = System.getenv("HOME");
		String kubeConfigPath = homePath + "/.kube/config";

		// loading the out-of-cluster config, a kubeconfig from file-system
		ApiClient client =
				ClientBuilder.kubeconfig(KubeConfig.loadKubeConfig(new FileReader(kubeConfigPath))).build();

		// set the global default api-client to the in-cluster one from above
		Configuration.setDefaultApiClient(client);
	}
	public static void main(String[] args) {
		SpringApplication.run(Eliotk8sclientApplication.class, args);
	}

}

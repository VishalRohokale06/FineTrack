package com.vr.finetrack_backend.service;

import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;
@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatClient chatClient;
    private final FinanceContextService financeContextService;

    public String ask(String question) {

        if (isFinanceQuestion(question)) {

            String context = financeContextService.buildContext();

            String prompt = """
        You are FinTrack AI, a personal finance advisor.

        User Financial Data:
        %s

        Question:
        %s

        Rules:
        - Keep answers under 3 lines.
        - Be direct and concise.
        - Use the user's actual financial data.
        - Include numbers when relevant.
        - Avoid long explanations.
        - Give actionable advice.
        - If the question is about saving money, mention the biggest spending category.
        - Reply like a finance assistant, not a teacher.

        Answer:
        """
                    .formatted(context, question);

            return chatClient
                    .prompt(prompt)
                    .call()
                    .content();
        }

        return chatClient
                .prompt(question)
                .call()
                .content();
    }

    private boolean isFinanceQuestion(String question) {

        String q = question.toLowerCase();

        return q.contains("salary")
                || q.contains("income")
                || q.contains("expense")
                || q.contains("budget")
                || q.contains("save")
                || q.contains("saving")
                || q.contains("money")
                || q.contains("spending")
                || q.contains("finance")
                || q.contains("afford")
                || q.contains("investment")
                || q.contains("loan");
    }
}
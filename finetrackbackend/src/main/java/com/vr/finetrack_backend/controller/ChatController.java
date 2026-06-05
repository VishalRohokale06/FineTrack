package com.vr.finetrack_backend.controller;

import com.vr.finetrack_backend.dto.ChatRequest;
import com.vr.finetrack_backend.dto.ChatResponse;
import com.vr.finetrack_backend.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService aiService;

    @PostMapping
    public ChatResponse chat(@RequestBody ChatRequest request){
        String answer = aiService.ask(request.getMessage());

        return new ChatResponse(answer);
    }
}

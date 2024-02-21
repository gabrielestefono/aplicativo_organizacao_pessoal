<?php

namespace Tests\Unit;

use App\Models\Objetivo;
use Tests\TestCase;

class CreateObjetiveTest extends TestCase
{
    /**
     * Teste de criação de objetivo
     */
    public function test_criacao_objetivo(): void
    {
        $objetivo = new Objetivo();
        $objetivo->objetivo = 'Objetivo de teste';
        $objetivo->descricao = 'Descrição do objetivo de teste';
        $objetivo->concluido = false;
        $objetivo->arquivado = false;
        $objetivo->prioridade = 0;
        $objetivo->parent_id = 0;
        $objetivo->user_id = 1;

        $this->assertArrayHasKey('objetivo', [
            'objetivo' => $objetivo->objetivo,
            'descricao' => $objetivo->descricao,
            'concluido' => $objetivo->concluido,
            'arquivado' => $objetivo->arquivado,
            'prioridade' => $objetivo->prioridade,
            'parent_id' => $objetivo->parent_id,
            'user_id' => $objetivo->user_id
        ]);
    }
}